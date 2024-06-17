const Company = require('../models/Company');
const Job = require('../models/Job');

const { multipleMongooseToObject } = require('../util/mongoose');
const { mongooseToObject } = require('../util/mongoose');

class JobController {
    getJob(req, res, next) {
        Job.find(req.query).then(jobs => {
            if (!jobs) {
                res.status(404).json({
                    message: 'Not found',
                });
            }
            var jobList = multipleMongooseToObject(jobs);
            var jobPrm = jobList.map(async (job) => {
                const company = await Company.findOne({ _id: job.companyId });
                return {
                    ...job,
                    company: mongooseToObject(company),
                }
            });
            Promise.all(jobPrm).then(jobs => {
                res.status(200).json({
                    jobs
                });
            });
        });
    }

    createJob(req, res, next) {
        if (req.body.companyId) {
            const jobCreate = new Job(req.body);
            jobCreate.save().then(() => {
                Job.findOne(jobCreate).then(job => {
                    res.status(201).json({
                        message: 'Create job successfully',
                        job
                    });
                });
            });
        } else {
            res.status(401).json({
                message: 'Sign in to create job'
            });
        }
    }
    
    updateJob(req, res, next) {
        Job.findOneAndUpdate(req.body.old, req.body.new).then(err => {
            if (err) console.log(err);
            res.status(201).json({
                message: 'Update successfully'
            });
        });
    }
}

module.exports = new JobController;