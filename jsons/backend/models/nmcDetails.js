const mongoose = require('mongoose');

const nmcDetails = new mongoose.Schema({
    nmcNumber: Number,
    fullName: String,
    address: String,
    gender: String,
    degree: String,
    email: String
});

module.exports = mongoose.model("NMC", nmcDetails);