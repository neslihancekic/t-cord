const User = require('../models/user');
const jwt = require('jsonwebtoken'); //generate signed token
const expressJwt = require('express-jwt'); // authorization check

const {errorHandler} = require("../helpers/dbErrorHandler");

const { sendResetPasswordEmail,sendPasswordChangedEmail} = require('../helpers/sendEmail');

exports.signUp = async (req,res) => {
    try{
        const user = new User(req.body);
        await user.save();
        user.salt = undefined
        user.hashedPassword = undefined
        res.respondCreated({user},'Account Created!');
    }catch (error) {
        res.fail(errorHandler(error));
    }
}

exports.signIn = (req,res) => {
    const{username,password} = req.body
    User.findOne({username}, ( error,user) => {
        //user exist control
        if (!user){
            return res.fail("User with that username does not exist. Please signup.");
        }
        //authenticate method in user model
        if(!user.authenticate(password)){
            return res.failUnauthorized('Username and password do not matched.');
        }
        if(error){
            return res.fail(error);
        }
        //generate a signed token with user id and secret
        const token = jwt.sign({_id:user._id}, process.env.JWT_SECRET)
        //persist the token as t in cookie with expiry date
        res.cookie('t', token, {expire: new Date() + 9999})
        return res.respond({token, user: user})
    });
};

exports.signOut = (req,res) => {
    res.clearCookie('t')
    res.respond({ message: "Signout Success"})
};

exports.requireSignin = expressJwt({
    secret: process.env.JWT_SECRET,
    algorithms: ["HS256"], // added later
    userProperty: "auth",
  });

exports.isAuth = (req,res,next) => {
    let user =  req.auth && req.header('UserId')==req.auth._id;
    if(!user){
        return res.failUnauthorized({
            error: "Access denied."
        });
    }
    next();
};

exports.recover = (req, res) => {
    User.findOne({email: req.body.email})
        .then(user => {
            if (!user) return res.failUnauthorized('The email address ' + req.body.email + ' is not associated with any account. Double-check your email address and try again.');

            //Generate and set password reset token
            user.generatePasswordReset();

            // Save the updated user object
            user.save()
                .then(user => {
                    // send email
                    sendResetPasswordEmail(res,user)
                })
                .catch(err => res.fail(err.message));
        })
        .catch(err => res.fail(err.message));
};


exports.resetPassword = (req, res) => {
    User.findOne({resetPasswordToken: req.params.token, resetPasswordExpires: {$gt: Date.now()}})
        .then((user) => {
            if (!user) return res.failUnauthorized('Password reset token is invalid or has expired.');
            //Set the new password
            user.password = req.body.password;
            user.resetPasswordToken = undefined;
            user.resetPasswordExpires = undefined;

            // Save
            user.save((err) => {
                if (err) return res.fail(err.message);
                sendPasswordChangedEmail(res,user)
                
            });
        });
};