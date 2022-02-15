const express = require("express")
const router = express.Router()

const { 
   create,
   compositionById,
   read,update,remove,list,like,addTrack,search,getContributers
} = require("../controllers/composition");

const { userById} = require("../controllers/user");
const { requireSignin, isAuth } = require("../controllers/auth");

router.post("/composition",requireSignin, isAuth,create);
router.get("/composition/:compositionId", read);
router.put("/composition/:compositionId", requireSignin, isAuth,update);
router.delete("/composition/:compositionId", requireSignin, isAuth,remove);


router.post("/addTrack/:compositionId", requireSignin,isAuth,addTrack);
router.put("/like/:compositionId", requireSignin, isAuth,like);

router.get("/contributers/:compositionId", getContributers);

router.get("/compositions", list);
router.get("/composition", search)

router.param('compositionId',compositionById )


module.exports = router;
