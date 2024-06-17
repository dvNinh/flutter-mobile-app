const User = require('../models/User');
const Company = require('../models/Company');
const Job = require('../models/Job');

const { multipleMongooseToObject } = require('../util/mongoose');
const { mongooseToObject } = require('../util/mongoose');

class SearchController {
    search(req, res, next) {
        var searchText = req.body.value;
        Job.find({ name: { $regex: searchText } }).then(jobs => {
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
}

module.exports = new SearchController;
