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
  startTime: {
    hour: {
      type: Number,
    },
    minute: {
      type: Number,
    },
  },
  times_a_day: {
    type: Number,
    required: true,
  },
  is_taken: {
    type: Array,
  },
  doseTime: [{
    type:Object,
  }],
});

module.exports = mongoose.model("reminder", reminder);
