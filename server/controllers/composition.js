const Composition = require('../models/composition')
const User = require('../models/user')
const Comment = require('../models/comment')
const {PythonShell} = require('python-shell');
const axios = require('axios');
var fs = require('fs');

async function download(url,dest){ 
    var file = fs.createWriteStream(dest);
    try {
        const response = await axios({
            url,
            method: 'GET',
            responseType: 'stream'
          })
       response.data.pipe(file)
       return new Promise((resolve, reject) => {
           file.on('finish', resolve)
           file.on('error', reject)
       })
    } catch (error) {
        console.log(error.response.body);
    }
}
exports.compositionById = (req,res,next,id) =>{
    Composition.findById(id).exec((err,composition) => {
        if(err||!composition){
            return res.failNotFound("Composition not found!"
            );
        }
        req.composition = composition;
        next();
    });
};

exports.create = (req,res) => {
    console.log(req.body)
    const message = new Composition(req.body)
    message.save((err, data) => {
        if(err) {
            return res.fail(err);
        }
        res.respond(data);
    }
    )
}


exports.read = (req,res) => {
    return res.respond(req.composition)

}

exports.update =(req,res) => {
    Composition.findOneAndUpdate({_id:req.composition._id}, {$set:req.body}, {new:true}, (err,composition)=>{
        if(err){
            return res.fail({
                error:err
            });
        }
        res.respond(composition)
    })
}

exports.remove =(req,res) => {
    Composition.deleteOne({_id:req.composition._id}, (err,composition)=>{
        if(err){
            return res.fail({
                error:err
            });
        }
        res.respond({ message:  "Composition deleted!"})
    })
}


exports.list = async(req,res) => {
    const compositions = await Composition.find().sort( { "createdAt": -1 } ).lean();
    for (const element of compositions) {
        const a = await User.find({'_id': { $in: element.tracks.slice(0).slice(-4).map(obj => obj['ownerUserId'])}})
        .select(['-_id','profilePhoto']);
        let x=[]
        const photos = a.map(obj => {
            x.push(obj['profilePhoto']??"")
        });
        element.userPhotos=x

        const commentCount =  await Comment.countDocuments({'compositionId': element._id,});
        element.commentCount=commentCount

        const pp =await User.findOne({'_id': element.ownerUserId,}) ;
        element.photo=pp['profilePhoto']??""
    }
    return res.respond({compositions})
}

exports.getContributers = async (req,res) => {
    const composition =  await Composition.findOne({_id:req.composition._id},);
    const userIds = composition.tracks.map(obj => obj['ownerUserId']);
    const users = await User.find({
        '_id': { $in: userIds}
    });
    return res.respond({users})
}

exports.like =async (req,res) => {
    let composition = await Composition.findOne({_id:req.composition._id}); 
    let user =  await User.findOne({ _id:req.header('UserId')});
    if( composition.likes.includes(req.header('UserId'))){
        composition.likes.pull(req.header('UserId'));
        user.likedCompositions.pull(req.composition._id)
    }else{
        composition.likes.push(req.header('UserId'));
        user.likedCompositions.push(req.composition._id)
        let owner =  await User.findOne({ _id:composition.ownerUserId});
        axios
        .post(`http://${req.headers.host}/firebase/notification`, {
            message:
            {
                notification: {
                    title: "You're liked!!!",
                    body: `${user.username} liked your composition`,
                    image: user.profilePhoto
                }
            },
            registrationToken:[owner.fcmToken],
            data: {
                senderUserId: req.header('UserId'),
                receiverUsersId: [owner._id],
                compositionId: composition._id,
                type: 0,
                title: "You're liked!!!",
                body: `${user.username} liked your composition`,
                image: user.profilePhoto
            }
          
        })
        .then(res => {
            console.log(`statusCode: ${res.status}`)
            console.log(res)
        })
        .catch(error => {
            console.error(error)
        })
    }
    await composition.save();
    await user.save();
    res.respond(composition)
}


exports.addTrack =async(req,res) => {
    await download(req.body.midi,"./temp.mid");
    await download(req.composition.midi,"./composition.mid");
    await download(req.body.audio,"./temp.wav");
    await download(req.composition.audio,"./composition.wav");

    const listOfUser = await User.find({'_id': { $in: req.composition.tracks.map(obj => obj['ownerUserId'])}})
    .select(['fcmToken']);
    let listOfUserId = [];
    let listOfFCM = [];
    listOfUser.forEach(element => {
        listOfUserId.push(element['_id']);
        listOfFCM.push(element['fcmToken']);
    });

    const user = await User.findOne({'_id': req.header('UserId')});
    var options = {
        //pythonPath: '/app/.heroku/python/bin/python3', //localde sil
        args:
        [
          "/temp",
          "/composition",
          req.headers.host
        ]
      }
    PythonShell.run('./python/add_track.py', options, function (err, data){
        if (err) throw err;
        // results is an array consisting of messages collected during execution
        console.log('results: %j', data);

        const comp = new Composition()
        comp.originOwnerUserId= req.composition.originOwnerUserId
        comp.ownerUserId= req.header('UserId')
        comp.tracks= req.composition.tracks
        comp.tracks.push(req.body)
        comp.username= req.body.username
        comp.title=req.body.title
        comp.info=req.body.info
        comp.midi=  data[1]
        comp.csv=  data[2]
        comp.sheetMusic=  data[3]
        comp.audio=  data[0]
        comp.save((err, data) => {
            if(err) {
                return res.fail(err);
            }
            axios
            .post(`http://${req.headers.host}/firebase/notification`, {
                message:
                {
                    notification: {
                        title: "New Composition!!!",
                        body: `${req.body.username} added new track to your composition`,
                        image: user.profilePhoto
                    }
                },
                registrationToken:listOfFCM,
                data: {
                    senderUserId: req.header('UserId'),
                    receiverUsersId: listOfUserId,
                    type: 2,
                    title: "New Composition!!!",
                    body: `${req.body.username} added new track to your composition`,
                    image: user.profilePhoto
                }
              
            })
            .then(res => {
                console.log(`statusCode: ${res.status}`)
                console.log(res)
            })
            .catch(error => {
                console.error(error)
            })
            res.respond(data);
        })
    });
    
}


exports.search =async (req,res) => {
    const compositions =  await Composition.find({ $or: [{ title: {$regex: req.query.search, $options: 'i'}  }, { info: {$regex: req.query.search, $options: 'i'}  }] }).sort( { "createdAt": -1 } ).lean();
    for (const element of compositions) {
        const a = await User.find({'_id': { $in: element.tracks.slice(0).slice(-4).map(obj => obj['ownerUserId'])}})
        .select(['-_id','profilePhoto']);
        let x=[]
        const photos = a.map(obj => {
            x.push(obj['profilePhoto']??"")
        });
        
        element.userPhotos=x
        const commentCount = await Comment.countDocuments({'compositionId': element._id,});
        element.commentCount=commentCount

        const pp =await User.findOne({'_id': element.ownerUserId,}) ;
        element.photo=pp['profilePhoto']??""
    }
    return res.respond({compositions})
}