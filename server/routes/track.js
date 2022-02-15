const express = require("express")
const router = express.Router()

const { 
   create,
   trackById,
   read,update,remove,csvToMidi,listbyIds
} = require("../controllers/track");
const { userById} = require("../controllers/user");

const { requireSignin, isAuth } = require("../controllers/auth");

router.get("/tracks", listbyIds);
router.post("/track", requireSignin,isAuth,create);
router.get("/track/:trackId", read);
router.put("/track/:trackId", requireSignin,isAuth,update);
router.delete("/track/:trackId", requireSignin,isAuth,remove);
router.put("/track/csvToMidi/:trackId", requireSignin,isAuth,csvToMidi);


router.param('trackId',trackById )


module.exports = router;
