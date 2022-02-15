const mongoose = require('mongoose')

const { ObjectId } = mongoose.Schema;

const commentSchema = new mongoose.Schema({
        userId: {
            type: ObjectId,
            ref: 'User',
            required: true
        },
        commentedUserId: {
            type: ObjectId,
            ref: 'User',
            required: true
        },
        username: {
            type: String,
            required: true,
        },
        photo: {
            type: String,
        },
        compositionId: {
            type: ObjectId,
            ref: 'Composition',
            required: true
        },
        comment:{
            type: String,
            required: true,
        }
    },
    {timestamps: true}
);

module.exports = mongoose.model("Comment",commentSchema);