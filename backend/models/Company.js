const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Company = new Schema({
    name: { type: String },
    address: { type: String },
    introduction: { type: String, default: '' },
    website: { type: String, default: '' },
    avatar: { type: String, default: '' },
    background: { type: String, default: '' },
    employerId: { type: String },
}, { timestamps: true });

module.exports = mongoose.model('Company', Company);
