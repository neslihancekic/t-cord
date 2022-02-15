const Notification = require('../models/notification');

exports.notificationById = (req,res,next,id) =>{
    Notification.findById(id).exec((err,notification) => {
        if(err||!notification){
            return res.failNotFound("Notification not found!"
            );
        }
        req.notification = notification;
        next();
    });
};

exports.getNotifications = async (req,res) => {
    const notifications =  await Notification.find({receiverUsersId:req.header('UserId')}).sort( { "createdAt": -1 } );  
    return res.respond({notifications})
}

exports.create = (req,res) => {
    const message = new Notification(req.body)
    message.save((err, data) => {
        if(err) {
            console.log(err)
            return res.fail({
                error:err
            });
        }
        res.respond(data);
    }
    )
}

exports.isRead =(req,res) => {
    Notification.findOneAndUpdate({_id:req.notification._id}, {$set:req.body}, {new:true}, (err,notification)=>{
        if(err){
            return res.fail({
                error:err
            });
        }
        res.respond(notification)
    })
}

exports.remove =(req,res) => {
    Notification.deleteOne({_id:req.notification._id}, (err,notification)=>{
        if(err){
            return res.fail({
                error:err
            });
        }
        res.respond({ message:  "Notification deleted!"})
    })
}
