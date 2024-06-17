const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Viewed = new Schema({
    userId: { type: String },
    jobId: { type: String },
}, { timestamps: true });

module.exports = mongoose.model('Viewed', Viewed);
