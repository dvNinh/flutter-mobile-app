const User = require('../models/User');
const Company = require('../models/Company');
const Job = require('../models/Job');

const { multipleMongooseToObject } = require('../util/mongoose');
const { mongooseToObject } = require('../util/mongoose');

class CompanyController {
    getCompany(req, res, next) {
        Company.find(req.query).then(companys => {
            if (!companys) {
                res.status(404).json({
                    message: 'Not found',
                });
            }
            var companyList = multipleMongooseToObject(companys);
            var companyPrm = companyList.map(async (company) => {
                const jobs = await Job.find({ companyId: company._id });
                var jobList = multipleMongooseToObject(jobs);
                const user = await User.findOne({ _id: company.employerId });
                var employer = mongooseToObject(user);
                return {
                    ...company,
                    jobs: jobList,
                    employer,
                };
            });
            Promise.all(companyPrm).then(companys => {
                res.status(200).json({
                    companys
                });
            });
        });
    }

    updateCompany(req, res, next) {
        Company.findOneAndUpdate(req.query, req.body, { new: true }).then((company, err) => {
            if (err) {
                res.status(404).json({
                    message: 'Company not found'
                });
            } else {
                Job.find({ companyId: company._id }).then(jobs => {
                    User.findOne({ _id: company.employerId }).then(user => {
                        var com = {
                            ...mongooseToObject(company),
                            jobs,
                            employer: mongooseToObject(user)
                        }
                        res.status(201).json({
                            message: 'Update successfully',
                            company: com
                        });
                    });
                });
            }
        });
    }
}

module.exports = new CompanyController;
