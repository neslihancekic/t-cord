const express = require("express")
const router = express.Router()

const { 
   create,
   remove,
   list,
   commentById,
} = require("../controllers/comment");

const { 
    compositionById,
 } = require("../controllers/composition");
 
const { requireSignin, isAuth } = require("../controllers/auth");

router.post("/comment",requireSignin, isAuth,create);
router.delete("/comment/:commentId", requireSignin, isAuth,remove);
router.get("/comments/:compositionId", list);


router.param('commentId',commentById )
router.param('compositionId',compositionById )

module.exports = router;