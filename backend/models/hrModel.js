const mongoose = require("mongoose");

const HR = new mongoose.Schema({
  date: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  url: {
    type: String,
    required: true,
  },
  patient_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "Patient",
  },
});

module.exports = mongoose.model("HR", HR);
