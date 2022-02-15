const express = require("express")
const {check} = require('express-validator');
const router = express.Router()

const { 
    signUp , 
    signIn, 
    signOut,reset,recover,resetPassword
} = require("../controllers/auth");

const { userSignupValidator } = require("../validators")

router.post("/signup", userSignupValidator, signUp);
router.post("/signin", signIn);
router.get("/signout", signOut);


router.post('/recover', recover);
router.post('/resetPassword/:token', resetPassword);


module.exports = router;
