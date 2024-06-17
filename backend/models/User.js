const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const User = new Schema({
    email: { type: String },
    password: { type: String },
    firstName: { type: String },
    lastName: { type: String },
    phoneNumber: { type: String },
    avatar: { type: String, default: '' },
    role: { type: String, enum: ['Candidate', 'Employer'], default: 'Candidate' },
    address: { type: String, default: '' },
    gender: { type: String, default: '' },
    dob: { type: String, default: '' },
    description: { type: String, default: '' }
}, { timestamps: true });

module.exports = mongoose.model('User', User);
