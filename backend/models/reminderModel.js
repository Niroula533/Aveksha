const mongoose = require("mongoose");

const reminder = new mongoose.Schema({
  patientId: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Patient",
  },
  name: {
    type: String,
    required: true,
  },
  dosage: Number,
  doseTime: [{
    time: String,
    isTaken: Number,
  }],
});

module.exports = mongoose.model("reminder", reminder);
