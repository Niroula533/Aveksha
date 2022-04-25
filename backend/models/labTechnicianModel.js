const mongoose = require("mongoose");
const labTechnicianModel = new mongoose.Schema({
  user_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref:"User",
  },
  specialities:{
      type: Array,
  },
});

module.exports = mongoose.model("LabTechnician", labTechnicianModel);
