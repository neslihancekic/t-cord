const mongoose = require('mongoose')

const { ObjectId } = mongoose.Schema;

const compositionSchema = new mongoose.Schema({
        originOwnerUserId: {
            type: ObjectId,
            ref: 'User',
            required: true
        }, 
        ownerUserId: {
            type: ObjectId,
            ref: 'User',
            required: true
        },
        username:{
            type: String,
            required: true,
        }, 
        title:{
            type: String,
        }, 
        info:{
            type: String,
        }, 
        tracks:{
            type: Array,
            required: true
        },
        midi:{
            type: String,
            trim: true,
            required: true,
        }, 
        csv:{
            type: String,
            trim: true,
            required: true,
        }, 
        audio:{
            type: String,
            trim: true,
            required: true,
        },
        sheetMusic:{
            type: String,
            trim: true,
            required: true,
        },
        likes:{
            type: Array,
        }
    },
    {timestamps: true}
);

module.exports = mongoose.model("Composition",compositionSchema);