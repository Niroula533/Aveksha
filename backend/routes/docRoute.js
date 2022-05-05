const router = require('express').Router();
const docCtrl = require('../controllers/docCtrl');
router.get('/', docCtrl.getAll);

module.exports = router;