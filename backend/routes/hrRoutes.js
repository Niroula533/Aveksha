const router = require('express').Router();
const hrCtrl = require('../controllers/hrCtrl');
router.post('/add',hrCtrl.addHR);
router.post('/get',hrCtrl.getHrs);
router.post('/delete',hrCtrl.delHr);
// router.get('/HR/:id',hrCtrl.getHrs);

module.exports = router;
