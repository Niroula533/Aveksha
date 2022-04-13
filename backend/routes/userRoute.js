const router = require("express").Router();
const userCtrl = require("../controllers/userCtrl");

router.post("/otpcheck", userCtrl.otpCheck);
router.post("/otpupdate", userCtrl.otpUpdate);
router.post("/register", userCtrl.register);
router.post("/login", userCtrl.login);
router.post('/',userCtrl.getUser);
// router.get('/logout', userCtrl.logout);
module.exports = router;
