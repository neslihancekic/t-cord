const express = require("express")
const router = express.Router()

const { userById, 
    read,
     update,
     remove,
     getUserCompositions,
     getUserDebutCompositions,
     getUserLikedCompositions,
     follow,
     search,getUserFollowers,getUserFollowing} = require("../controllers/user");
const { requireSignin, isAuth } = require("../controllers/auth");

router.get('/secret/:userId', requireSignin, isAuth, (req,res)=>{
    res.respond({
        user: req.user
    });
});

router.get("/user/:userId", read)
router.put("/user",requireSignin, isAuth, update)
router.delete("/user",requireSignin, isAuth, remove)

router.get("/user/:userId/compositions", getUserCompositions)
router.get("/user/:userId/debuts", getUserDebutCompositions)
router.get("/user/:userId/liked", getUserLikedCompositions)

router.get("/user/:userId/followers", getUserFollowers)
router.get("/user/:userId/following", getUserFollowing)

router.put("/follow", requireSignin, isAuth,follow);

router.get("/user", search)

router.param('userId',userById )


module.exports = router;
