const User = require('../models/user')
const Composition = require('../models/composition');
const Comment = require('../models/comment');
const axios = require('axios');

exports.userById = (req,res,next,id) =>{
    User.findById(id).exec((err,user) => {
        if(err||!user){
            return res.failNotFound("User not found!");
        }
        req.user = user;
        next();
    });
};

exports.read = async (req,res) => {
    var fullName = req.user.firstName + " "+req.user.firstName 
    var followerCount=req.user.followers.length
    var followingCount=req.user.following.length
    var likedCompositionCount=req.user.likedCompositions.length
    const compositions =  await Composition.find({ ownerUserId: req.user._id });
    var compositionCount=compositions!=null?compositions.length:0
    const debutCompositions = await Composition.find({ originOwnerUserId: req.user._id });
    var debutCompositionCount=debutCompositions!=null?debutCompositions.length:0
    const {_id,username,profilePhoto,profileInfo}=req.user
    return res.respond({user: {_id, fullName,username,profilePhoto,profileInfo,followerCount,followingCount,compositionCount,debutCompositionCount,likedCompositionCount}})

}

exports.getUserCompositions = async (req,res) => {
    const compositions =  await Composition.find({ ownerUserId: req.user._id }).sort( { "createdAt": -1 } ).lean();  
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
exports.getUserLikedCompositions = async (req,res) => {
    const compositions = await  Composition.find({ _id: {$in: req.user.likedCompositions }}).sort( { "createdAt": -1 } ).lean();
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
exports.getUserDebutCompositions = async (req,res) => {
    const compositions = await Composition.find({ originOwnerUserId: req.user._id }).sort( { "createdAt": -1 } ).lean();
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
exports.getUserFollowers = async (req,res) => {
    const users = await  User.find({ _id: {$in: req.user.followers }}).select(['-salt','-hashedPassword','-likedComposition']).lean();
    users.forEach(element =>element.isFollowing=element.followers.some(function (friend) {
        return friend.equals(req.header('UserId'));
    }));
    return res.respond({users})
}
exports.getUserFollowing = async (req,res) => {
    const users = await  User.find({ _id: {$in: req.user.following }}).select(['-salt','-hashedPassword','-likedComposition']).lean();
    users.forEach(element =>element.isFollowing=element.followers.some(function (friend) {
        return friend.equals(req.header('UserId'));
    }));
    return res.respond({users})
}

exports.update =async(req,res) => {
    User.findOneAndUpdate({_id:req.header('UserId')}, {$set:req.body}, {new:true}, (err,user)=>{
        if(err){
            return res.fail({
                error:"You are not authorize!"
            });
        }
        user.hashedPassword = undefined
        user.salt = undefined
        user.followers = undefined
        user.following = undefined
        user.likedCompositions = undefined
        res.respond(user)
    })
}

exports.remove =async(req,res) => {
    await User.deleteOne({_id:req.header('UserId')}, (err,user)=>{
        if(err){
            return res.status(400)
        }
        res.respond({ message:  "User deleted!"})
    })
}

exports.follow =async (req,res) => {
    let follower = await User.findOne({_id:req.header('UserId')}); 
    let following =  await User.findOne({ _id:req.body.userId});
    if(follower.following.includes(following._id)){
        follower.following.pull(following._id);
        following.followers.pull(follower._id)
    }else{
        follower.following.push(following._id);
        following.followers.push(follower._id);
        axios
        .post(`http://${req.headers.host}/firebase/notification`, {
            message:
            {
                notification: {
                    title: "You're followed!!!",
                    body: `${follower.username} followed you`,
                    image: follower.profilePhoto
                }
            },
            registrationToken:[following.fcmToken],
            data: {
                senderUserId: req.header('UserId'),
                receiverUsersId: [following._id],
                type: 1,
                title: "You're followed!!!",
                body: `${follower.username} followed you`,
                image: follower.profilePhoto
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
    await follower.save();
    await following.save();
    res.respond(follower)
}



exports.search =async (req,res) => {
    const users =  await User.find({ $or: [{ username: {$regex: req.query.search, $options: 'i'}  }, { firstName: {$regex: req.query.search, $options: 'i'}  }, { lastName: {$regex: req.query.search, $options: 'i'}  }] })
    .select(['-salt','-hashedPassword'])
    .limit(Number(req.query.pageLimit))
    .skip(Number(req.query.pageLimit) * Number(req.query.pageNumber));
    return res.respond({users})
}
