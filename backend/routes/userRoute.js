const router = require("express").Router();
const userCtrl = require("../controllers/userCtrl");

router.post("/otpcheck", userCtrl.otpCheck);
router.post("/register", userCtrl.register);
router.post("/login", userCtrl.login);
router.post("/rating", userCtrl.rating);
router.post("/getFeedback", userCtrl.getFeedback);
// router.get('/logout', userCtrl.logout);
module.exports = router;
