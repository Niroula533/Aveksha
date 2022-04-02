const mongoose = require("mongoose");

const EHR = new mongoose.Schema({
  date: {
    type: Date,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  file: {
    type: Blob,
  },
  patient_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Patient",
  },
});

module.exports = mongoose.model("EHR", EHR);
