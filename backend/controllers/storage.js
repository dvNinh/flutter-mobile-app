const User = require('../models/User');
const Company = require('../models/Company');
const Job = require('../models/Job');
const Viewed = require('../models/Viewed');
const Saved = require('../models/Saved');
const Applied = require('../models/Applied');

const { multipleMongooseToObject } = require('../util/mongoose');
const { mongooseToObject } = require('../util/mongoose');

class StorageController {
    getViewed(req, res, next) {
        Viewed.find(req.query).then(vieweds => {
            if (!vieweds) {
                res.status(200).json({
                    vieweds: []
                });
            }
            var viewedList = multipleMongooseToObject(vieweds);
            var viewedPrm = viewedList.map(async (viewed) => {
                var user = await User.findOne({ _id: viewed.userId });
                user = mongooseToObject(user);
                var job = await Job.findOne({ _id: viewed.jobId });
                job = mongooseToObject(job);
                var company = await Company.findOne({ _id: job.companyId });
                company = mongooseToObject(company);
                return {
                    user,
                    job: {
                        ...job,
                        company
                    },
                }
            });
            Promise.all(viewedPrm).then(vieweds => {
                res.status(200).json({
                    vieweds
                });
            });
        });
    }

    postViewed(req, res, next) {
        Viewed.findOne(req.body).then(viewed => {
            if (!viewed) {
                const viewedCreate = new Viewed(req.body);
                viewedCreate.save();
                res.status(201).json({
                    message: 'Success'
                });
            }
        });
    }

    getSaved(req, res, next) {
        Saved.find(req.query).then(saveds => {
            if (!saveds) {
                res.status(200).json({
                    saveds: []
                });
            }
            var savedList = multipleMongooseToObject(saveds);
            var savedPrm = savedList.map(async (saved) => {
                var user = await User.findOne({ _id: saved.userId });
                user = mongooseToObject(user);
                var job = await Job.findOne({ _id: saved.jobId });
                job = mongooseToObject(job);
                var company = await Company.findOne({ _id: job.companyId });
                company = mongooseToObject(company);
                return {
                    user,
                    job: {
                        ...job,
                        company
                    },
                }
            });
            Promise.all(savedPrm).then(saveds => {
                res.status(200).json({
                    saveds
                });
            });
        });
    }

    postSaved(req, res, next) {
        Saved.findOne(req.body).then(saved => {
            if (!saved) {
                const savedCreate = new Saved(req.body);
                savedCreate.save();
                res.status(201).json({
                    message: 'Success'
                });
            }
        });
    }

    getApplied(req, res, next) {
        Applied.find(req.query).then(applieds => {
            if (!applieds) {
                res.status(200).json({
                    applieds: []
                });
            }
            var appliedList = multipleMongooseToObject(applieds);
            var appliedPrm = appliedList.map(async (applied) => {
                var user = await User.findOne({ _id: applied.userId });
                user = mongooseToObject(user);
                var job = await Job.findOne({ _id: applied.jobId });
                job = mongooseToObject(job);
                var company = await Company.findOne({ _id: job.companyId });
                company = mongooseToObject(company);
                return {
                    user,
                    job: {
                        ...job,
                        company
                    },
                }
            });
            Promise.all(appliedPrm).then(applieds => {
                res.status(200).json({
                    applieds
                });
            });
        });
    }

    postApplied(req, res, next) {
        Applied.findOne(req.body).then(applied => {
            if (!applied) {
                const appliedCreate = new Applied(req.body);
                appliedCreate.save();
                res.status(201).json({
                    message: 'Success'
                });
            }
        });
    }

    async getAppliedByCompanyId(req, res, next) {
        const jobs = await Job.find({ companyId: req.query.companyId });
        let jobList = multipleMongooseToObject(jobs);
        let appliedPrm = jobList.map(async (job) => {
            let applieds = await Applied.find({ jobId: job._id });
            let appliedList = multipleMongooseToObject(applieds);
            return appliedList;
        });
        Promise.all(appliedPrm).then(applieds => {
            let appliedList = [];
            for (let applied of applieds) {
                for (let e of applied) {
                    appliedList.push(e)
                }
            }
            let appliedPrm = appliedList.map(async (applied) => {
                let job = await Job.findOne({ _id: applied.jobId });
                let user = await User.findOne({ _id: applied.userId });
                return {
                    job,
                    user
                };
            });
            Promise.all(appliedPrm).then(applieds => {
                res.status(200).json({
                    message: 'Success',
                    applieds
                });
            })
        });
    }
}

module.exports = new StorageController;
