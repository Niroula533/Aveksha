const mongoose = require("mongoose");
const User = new mongoose.Schema({
  firstName: {
    type: String,
    required: true,
  },
  lastName: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  phone: {
    type: Number,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  role: {
    type: Number,
    default: 0,
  },
  address: {
    type: String,
    required: true,
  },
  otp: {
    type: Number,
  },
  confirmed: {
    type: Boolean,
    default: false,
  },
});

module.exports = mongoose.model("User", User);
