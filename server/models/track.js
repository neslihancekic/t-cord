const mongoose = require('mongoose')

const { ObjectId } = mongoose.Schema;

const trackSchema = new mongoose.Schema({
        ownerUserId: {
            type: ObjectId,
            ref: 'User',
            required: true
        },
        username:{
            type: String,
            required: true,
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
        }
        
    },
    {timestamps: true}
);

module.exports = mongoose.model("Track",trackSchema);