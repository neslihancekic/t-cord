const Comment = require('../models/comment')
const User = require('../models/user')
const axios = require('axios');
var fs = require('fs');

exports.commentById = (req,res,next,id) =>{
    Comment.findById(id).exec((err,comment) => {
        if(err||!comment){
            return res.failNotFound("Comment not found!"
            );
        }
        req.comment = comment;
        next();
    });
};

exports.create = async (req,res) => {
    console.log(req.body)
    const message = new Comment(req.body)

    let commented =  await User.findOne({ _id:req.header('UserId')});
    let owner =  await User.findOne({ _id:req.body.userId});
    message.photo=commented.profilePhoto
    message.username=commented.username
    message.save((err, data) => {
        if(err) {
            return res.fail(err);
        }


        axios
        .post(`http://${req.headers.host}/firebase/notification`, {
            message:
            {
                notification: {
                    title: "New Comment!!!",
                    body: `${commented.username} commented your composition`,
                    image: commented.profilePhoto
                }
            },
            registrationToken:[owner.fcmToken],
            data: {
                senderUserId: req.header('UserId'),
                receiverUsersId: [owner._id],
                compositionId: req.body.compositionId,
                type: 3,
                title: "New Comment!!!",
                body: `${commented.username} commented your composition`,
                image: commented.profilePhoto
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
    }
    )
}

exports.remove =(req,res) => {
    Comment.deleteOne({_id:req.comment._id}, (err,comment)=>{
        if(err){
            return res.fail({
                error:err
            });
        }
        res.respond({ message:  "Comment deleted!"})
    })
}


exports.list = async(req,res) => {
    const comments =  await Comment.find({compositionId:req.composition._id});  
    return res.respond({comments})
}
