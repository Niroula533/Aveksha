const mongoose = require("mongoose");

const feedback = new mongoose.model({
  comment: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    required: true,
  },
  patient_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "Patient",
  },
  doctor_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "Doctor",
  },
});

module.exports = mongoose.model("feedback", feedback);
