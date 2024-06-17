const express = require('express');
const router = express.Router();

const userController = require('./controllers/user');
const companyController = require('./controllers/company');
const jobController = require('./controllers/job');
const searchController = require('./controllers/search');
const storageController = require('./controllers/storage');

router.post('/sign-in', userController.signIn);
router.post('/sign-up', userController.signUp);
router.post('/user/update', userController.updateProfile);

router.get('/company', companyController.getCompany);
router.post('/company/update', companyController.updateCompany);

router.get('/job', jobController.getJob);
router.post('/job', jobController.createJob);
router.put('/job', jobController.updateJob);

router.post('/search', searchController.search);

router.get('/viewed', storageController.getViewed);
router.post('/viewed', storageController.postViewed);

router.get('/saved', storageController.getSaved);
router.post('/saved', storageController.postSaved);

router.get('/applied', storageController.getApplied);
router.get('/applied/company', storageController.getAppliedByCompanyId);
router.post('/applied', storageController.postApplied);

module.exports = router;