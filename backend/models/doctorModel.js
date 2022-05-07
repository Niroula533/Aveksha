const mongoose = require("mongoose");
const Doctor = new mongoose.Schema({
  user_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"User",
  },
  hospital: String,
  nmc:{
    type: Number,
    required: true,
    unique:true,
  },
  availability:[{
      type: Object
  }],
  speciality:String,
});

module.exports = mongoose.model("Doctor", Doctor);
