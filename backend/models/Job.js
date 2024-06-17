const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Job = new Schema({
    name: { type: String },
    salary: { type: String },
    address: { type: String },
    description: { type: String },
    requirements: { type: String },
    tags: { type: Array, default: [] },
    companyId: { type: String },
}, { timestamps: true });

module.exports = mongoose.model('Job', Job);
