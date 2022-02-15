const express = require("express")
const router = express.Router()

const {notificationById,create,getNotifications,remove,isRead} = require("../controllers/notification");
const { requireSignin, isAuth } = require("../controllers/auth");


router.post("/notification", create)

router.delete("/notification/:notificationId", requireSignin, isAuth,remove);
router.get("/notifications", requireSignin, isAuth,getNotifications)
router.put("/notification/:notificationId/isRead", requireSignin, isAuth,isRead)

router.param('notificationId',notificationById )
module.exports = router;
