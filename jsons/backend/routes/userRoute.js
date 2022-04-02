const router = require("express").Router();
const userCtrl = require("../controllers/userCtrl");

router.post("/otpcheck", userCtrl.otpCheck);
router.post("/register", userCtrl.register);
router.post("/login", userCtrl.login);
// router.get('/logout', userCtrl.logout);
module.exports = router;
