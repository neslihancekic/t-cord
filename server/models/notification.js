const mongoose = require('mongoose')

const { ObjectId } = mongoose.Schema;

const notificationSchema = new mongoose.Schema({
        senderUserId: {
            type: ObjectId,
            ref: 'User',
            required: true
        },
        receiverUsersId:{
            type: Array,
        },
        compositionId: {
            type: ObjectId,
            ref: 'Composition',
        },
        commentId: {
            type: ObjectId,
            ref: 'Comment',
        },
        type:{ //0->like, 1->follow, 2->addedNewTrack, 3->comment
            type: Number,
            required: true,
        },
        title:{
            type: String,
            required: true,
        },
        body:{
            type: String,
            required: true,
        },
        image:{
            type: String,
        },
        isRead:{
            type: Boolean,
            default: false,
        }
    },
    {timestamps: true}
);

module.exports = mongoose.model("Notification",notificationSchema);