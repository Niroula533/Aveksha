const router = require('express').Router();
const docCtrl = require('../controllers/docCtrl');
router.post('/getAllAppointments', docCtrl.getAllAppointments);
router.put('/updateAppointments', docCtrl.updateAppointments);
router.get('/', docCtrl.getAll);

module.exports = router;