const Doctors = require("../models/doctorModel");
const jwt = require('jsonwebtoken')
const User = require("../models/userModel");
const LabTech = require("../models/labTechnicianModel");
const Appointments = require("../models/appointmentModel")

const docCtrl = {
  // getAppointments: async(req,res) =>{
  //   try {
  //     var doctor;
  //     const id = req.params.id;
  //     console.log(id);
  //     if(!id){
  //       const { accessToken, refreshToken } = req.body;
  //       const gotUser = jwt.verify(
  //       accessToken,
  //       process.env.ACCESS_TOKEN,
  //       (err, decoded) => {
  //         if (err) {
  //           const decod = jwt.verify(
  //             refreshToken,
  //             process.env.REFRESH_TOKEN,
  //             (err, user) => {
  //               if (err)
  //                 return res
  //                   .status(400)
  //                   .json({ msg: "Invalid authentication" });
  //               const accesstoken = createAccessToken(user);
  //               return { ...user, accesstoken };
  //             }
              
  //           );

  //           return decod;
  //         }

  //         return decoded;
  //       }


  //     );
  //     doctor = await Doctors.findOne({ user_id: gotUser.userId });
  //     } else{
  //       doctor = await Doctors.findOne({ user_id: id });
  //     }
  //     const appointments = await Appointments.find({ doctor_Id: doctor._id });
  //     return res.json(appointments);
  //     } catch (err) {
  //     return res.status(500).json({ msg: err.message });
  //   }
  // },

  updateAppointments: async(req,res) =>{
    try{
      const { id, status } = req.body;
      await Appointments.findByIdAndUpdate(
        id, {$set: {status: status}}
      ) 
    }
    catch(err){
      return res.status(500).json({ msg: err.message });
    }
  },

  getAllAppointments: async (req, res) => {
    try {
      var user;
      const { id, role } = req.body;
      if (!id) {
        const { accessToken } = req.body;
        const gotUser = jwt.verify(
          accessToken,
          process.env.ACCESS_TOKEN,
          (err, decoded) => {
            if (err) {
              console.log(err);
            }
            return decoded;
          }
        );
        if (role == 0) {
          user = await Patient.findOne({ user_id: gotUser.userId });
        } else if (role == 1) {
          user = await Doctors.findOne({ user_id: gotUser.userId });
        } else {
          user = await LabTech.findOne({ user_id: gotUser.userId });
        }
      } else {
        if (role == 0) {
          user = await Patient.findOne({ user_id: id });
        } else if (role == 1) {
          user = await Doctors.findOne({ user_id: id });
        } else {
          user = await LabTech.findOne({ user_id: id });
        }
      }
      var appointments;
      if(role == 1|| role == 2){
        appointments = await Appointments.find({ doctor_id: user.user_id });
      } else{
        appointments = await Appointments.find({ patient_id: user.user_id });
      }
      // console.log(appointments);
      return res.json(appointments);
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },



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
