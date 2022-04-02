const mongoose = require("mongoose");
const Doctor = new mongoose.Schema({
  user_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"User",
  },
  nmc:{
    type: Number,
    required: true,
    unique:true,
  },
  availability:[{
      type: Object
  }],
  specialities:{
      type: Array,
  },
});

module.exports = mongoose.model("Doctor", Doctor);
