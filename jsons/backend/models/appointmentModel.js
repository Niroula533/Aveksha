const mongoose = require("mongoose");

const appointment = new mongoose.Schema({
  status: {
    type: String,
    required: true,
  },
  date: {
    type: Date,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  patient_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Patient",
  },
  doctor_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Doctor",
  },
});

module.exports = mongoose.model("appointment", appointment);
