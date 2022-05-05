const Doctors = require("../models/doctorModel");
const User = require("../models/userModel");
const LabTech = require("../models/labTechnicianModel");

const docCtrl = {
  getAll: async (req, res) => {
    try {
      const users = await User.find(
        { role: { $in: [1, 2] } },
        { _id: 1, firstName: 1, email: 1, phone: 1 ,confirmed: 1}
      );

      const doctors = await Doctors.find();
      const labTechs = await LabTech.find();
      if (!doctors || !users) return res.json({ msg: "No doctors!" });
      const docUsers = users.map((value) => {
        if (!value.confirmed) return;
        const doc = doctors.find(
          (v) => v.user_id.toString() == value._id.toString()
        );
        if (!doc) return;
        const dUser = {
          userId: value._id,
          firstName: value.firstName,
          email: value.email,
          phone: value.phone,
          speciality: doc.speciality,
          booked: doc.booked,
          availability: doc.availability,
          hospital: doc.hospital,
        };
        return dUser;
      });
      const labUsers = users.map((value) => {
        console.log(value);
        if (!value.confirmed) return;
        const labT = labTechs.find(
          (v) => v.user_id.toString() == value._id.toString()
        );
        if (!labT) return;
        const lUser = {
          userId: value._id,
          firstName: value.firstName,
          email: value.email,
          phone: value.phone,
          speciality: labT.speciality,
          hospital: labT.hospital,
        };
        return lUser;
      });
      // console.log(labUsers);
      const filteredDoc = docUsers.filter((e) => (e ? true : false));
      const filteredLabTechs = labUsers.filter((e) => (e ? true : false));
      return res.json({ doctors: filteredDoc, labTechs: filteredLabTechs });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = docCtrl;
