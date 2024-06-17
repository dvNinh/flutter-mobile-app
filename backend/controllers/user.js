const User = require('../models/User');
const Company = require('../models/Company');
const Job = require('../models/Job');

const { multipleMongooseToObject } = require('../util/mongoose');
const { mongooseToObject } = require('../util/mongoose');

class UserController {
    signIn(req, res, next) {
        User.findOne(req.body).then(user => {
            if (!user) {
                res.status(401).json({
                    message: 'Password is incorrect'
                });
            } else if (user.role === 'Candidate') {
                req.session.user = user;
                res.status(201).json({
                    message: 'Sign in successfully',
                    user
                });
            } else {
                Company.findOne({ employerId: user._id }).then(company => {
                    Job.find({ companyId: company._id }).then(jobs => {
                        var com = {
                            ...mongooseToObject(company),
                            jobs,
                            employer: user
                        }
                        res.status(201).json({
                            message: 'Sign in successfully',
                            user,
                            company: com
                        });
                    });
                });
            }
        }).catch(next);
    }

    signUp(req, res, next) {
        User.findOne({ email: req.body.email }).then(user => {
            if (user) return res.status(401).json({
                message: 'Email already exists'
            });
            if (req.body.role === 'Candidate') {
                const userCreate = new User(req.body);
                userCreate.save();
                res.status(201).json({
                    message: 'Sign up successfully'
                });
            } else if (req.body.role === 'Employer') {
                const userCreate = new User({
                    firstName: req.body.firstName,
                    lastName: req.body.lastName,
                    email: req.body.email,
                    phoneNumber: req.body.phoneNumber,
                    password: req.body.password,
                    role: 'Employer'
                });
                userCreate.save().then(user => {
                    const companyCreate = new Company({
                        name: req.body.companyName,
                        address: req.body.companyAddress,
                        employerId: user._id,
                    });
                    companyCreate.save();
                    res.status(201).json({
                        message: 'Sign up successfully'
                    });
                });
            } else {
                res.status(401).json({
                    message: 'Invalid role'
                }); 
            }
        })
        .catch(next);
    }

    updateProfile(req, res, next) {
        User.findOneAndUpdate(req.query, req.body, { new: true }).then((user, err) => {
            if (err) {
                res.status(404).json({
                    message: 'User not found'
                });
            } else {
                res.status(201).json({
                    message: 'Update successfully',
                    user
                });
            }
        });
    }
}

module.exports = new UserController;
