const mongoose = require("mongoose");

const feedback = new mongoose.Schema({
  comment: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    required: true,
  },
  firstName: String,
  patient_user_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Patient",
  },
  doctor_user_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"Doctor",
  },
});

module.exports = mongoose.model("feedback", feedback);
