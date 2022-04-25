const mongoose = require("mongoose");
const Patient = new mongoose.Schema({
  user_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "User",
  },
  DOB: {
    type: String,
    required: true,
  },
  gender:{
    type: String,
    required: true,
  }
});

module.exports = mongoose.model("Patient", Patient);
