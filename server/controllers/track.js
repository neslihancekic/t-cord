const Track = require('../models/track')
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

exports.create = (req,res) => {
    console.log(req.body)
    const message = new Track(req.body)
    message.save((err, data) => {
        if(err) {
            console.log(err)
            return res.fail({
                error: errorHandler(err)
            });
        }
        res.respond(data);
    }
    )
}

exports.trackById = (req,res,next,id) =>{
    Track.findById(id).exec((err,track) => {
        if(err||!track){
            return res.failNotFound("Track not found!");
        }
        req.track = track;
        next();
    });
};

exports.read = (req,res) => {
    return res.respond(req.track)

}

exports.update =(req,res) => {
    Track.findOneAndUpdate({_id:req.track._id}, {$set:req.body}, {new:true}, (err,track)=>{
        if(err){
            return res.fail({
                error:"You are not authorize!"
            });
        }
        res.respond(track)
    })
}

exports.remove =(req,res) => {
    Track.deleteOne({_id:req.track._id}, (err,track)=>{
        if(err){
            return res.status(400)
        }
        res.respond({ message:  "Track deleted!"})
    })
}

exports.listbyIds = async (req,res) => {
    try{
        const tracks = await  Track.find({ _id: {$in: JSON.parse(JSON.stringify(req.body))}})
        return res.respond({tracks})
    }catch(err){
        return res.fail({error:err})
    }
}

exports.csvToMidi =async(req,res) => {
    var body = {} 
    body['csv']=req.body.csv
    await download(req.body.csv,"./temp.csv");
    var options = {
        //pythonPath: '/app/.heroku/python/bin/python3', //localde sil
        args:
        [
          "/temp.csv",
          req.headers.host
        ]
      }
    PythonShell.run('./python/csv_to_midi.py', options, function (err, data) {
        if (err) throw err;
        // results is an array consisting of messages collected during execution
        console.log('results: %j', data);
        body['midi']=data[0]
        Track.findOneAndUpdate({_id:req.track._id}, {$set:body}, {new:true}, (err,track)=>{
            if(err){
                return res.fail({
                    error:"err."
                });
            }
            res.respond(track)
        })
    });
    
}
