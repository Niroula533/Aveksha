const mongoose = require("mongoose");
const labTechnicianModel = new mongoose.Schema({
  user_id: {
    type: mongoose.SchemaTypes.ObjectId,
    ref: "User",
  },
  hospital: String,
  speciality: String,
});

module.exports = mongoose.model("LabTechnician", labTechnicianModel);
