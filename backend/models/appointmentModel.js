const mongoose = require("mongoose");

const appointments = new mongoose.Schema({
  status: {
    type: String,
  },
  date: {
    type: Date,
  },
  time:{
    type: String,
  },
  hour:{
    type: Number,
  },
  problem:{
    type: String,
  },
  patient_Name: {
    type: String,
    ref:"Patient",
  },
  patient_id:{
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Patient",
  },
  doctor_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Doctor",
  },
});

module.exports = mongoose.model("appointment", appointments);
