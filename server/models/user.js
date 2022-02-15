const mongoose = require('mongoose')
const crypto = require('crypto')
const { v1: uuidv1 } = require('uuid');

const userSchema = new mongoose.Schema({
        fcmToken:{
            type: String,
        },
        firstName:{
            type: String,
            trim: true,
            required: true,
            maxlength: 32
        },
        lastName:{
            type: String,
            trim: true,
            required: true,
            maxlength: 32
        }, 
        email:{
            type: String,
            trim: true,
            required: true,
            unique: true
        },
        username:{
            type: String,
            trim: true,
            required: true,
            unique: true,
            lowercase:true,
        }, 
        profilePhoto:{
            type: String,
            trim: true
        },
        profileInfo:{
            type: String
        },
        hashedPassword:{
            type: String,
            required: true,
        },
        salt: String,
        followers:{
            type: Array,
        },
        following:{
            type: Array,
        },
        likedCompositions:{
            type: Array,
        },

        resetPasswordToken: {
            type: String,
            required: false
        },
    
        resetPasswordExpires: {
            type: Date,
            required: false
        }
        
    },
    {timestamps: true}
);

// virtual field
userSchema.virtual('password')
.set(function(password){
    this._password = password
    this.salt = uuidv1()
    this.hashedPassword = this.encryptPassword(password)
})
.get(function(){
    return this._password
});

userSchema.methods = {
    authenticate: function(plainText){
        return this.encryptPassword(plainText) === this.hashedPassword;
    },

    encryptPassword: function(password){
        if(!password) return ""
        try{
            return crypto.createHmac('sha1', this.salt)
                        .update(password)
                        .digest('hex')
        }catch(err){
            return "";
        }
    },
    generatePasswordReset: function(){
        this.resetPasswordToken = crypto.randomBytes(3).toString('hex');
        this.resetPasswordExpires = Date.now() + 300000; //expires in five hours
    }
};

module.exports = mongoose.model("User",userSchema);