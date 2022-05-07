const mongoose = require("mongoose");

const appointment = new mongoose.Schema({
  status: {
    type: String,
  },
  date: {
    type: String,
  },
  time: {
    type: String,
  },
  hour:Number,
  problem: {
    type: String,
  },
  patient_Name: {
    type: String,
  },
  patient_id:{
    type: mongoose.SchemaTypes.ObjectId,
    ref: "Patient",
  },
  doctor_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "Doctor",
  },
});

module.exports = mongoose.model("appointment", appointment);
