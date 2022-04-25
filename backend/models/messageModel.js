const mongoose = require("mongoose");

const message = new mongoose.Schema({
  text: String,
  file: Blob,
  time: Date,
  patient_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "Patient",
  },
  doctor_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "Doctor",
  },
});

module.exports = mongoose.model("message", message);
