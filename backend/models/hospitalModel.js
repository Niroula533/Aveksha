const mongoose = require("mongoose");

const hospitalModel = new mongoose.Schema({
  hospitalName: String,
  labTechnicians: [
    {
      fullName: String,
      address: String,
      gender: String,
      degree: String,
      email: String,
    },
  ],
  doctors: [
    {
      nmcNumber: Number,
      fullName: String,
      address: String,
      gender: String,
      degree: String,
      email: String,
    },
  ],
});

module.exports = mongoose.model("hospital", hospitalModel);
