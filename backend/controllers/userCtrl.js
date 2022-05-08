const User = require("../models/userModel");
const Patient = require("../models/patientModel");
const Doctor = require("../models/doctorModel");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const hospitalModel = require("../models/hospitalModel");
const labTechnicianModel = require("../models/labTechnicianModel");
const Reminder = require("../models/reminderModel");
const feedback = require("../models/feedbackModel");
require("dotenv").config();

var generateOtp = async (email) => {
  var generatedOtp = Math.floor(100000 + Math.random() * 900000);
  generatedOtp = parseInt(generatedOtp);

  let transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    service: "Gmail",
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASS,
    },
  });

  var mailOptions = {
    to: email,
    subject: "Otp for registration is: ",
    html:
      "<h3>OTP for account verification is </h3>" +
      `<h1 style='font-weight:bold;'> 
      ${generatedOtp} 
      </h1>`, // html body
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      return console.log(error);
    }
    console.log("Message sent: %s", info.messageId);
    console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
  });
  return generatedOtp;
};

const userCtrl = {
  otpUpdate: async (req, res) => {
    try {
      const { email } = req.body;
      var otp = await generateOtp(email);
      await User.findOneAndUpdate({ email }, { $set: { otp: otp } });
      return res.json({ msg: "Otp updated successfully!" });
    } catch (e) {
      return res.status(500).json({ msg: error.message });
    }
  },

  otpCheck: async (req, res) => {
    try {
      const { otp, email } = req.body;

      const user = await User.findOne({ email, otp });
      if (user) {
        await User.updateOne({ email, otp }, { $set: { confirmed: true } });
        return res.status(200).json({ msg: "Account is verified" });
      } else {
        return res.status(400).json({ msg: "error , invalid token code" });
      }
    } catch (error) {
      return res.status(500).json({ msg: error.message });
    }
  },

  register: async (req, res) => {
    try {
      const { firstName, lastName, email, phone, password, role, address } =
        req.body;
      const user = await User.findOne({ email });
      if (user) return res.status(400).json({ msg: "User already exists" });
      if (password.length < 8) {
        return res
          .status(400)
          .json({ msg: "Password must be of at least 8 characters!" });
      }
      const encryptedPass = await bcrypt.hash(password, 10);

      var otpp = generateOtp(email);

      const newUser = new User({
        firstName,
        lastName,
        email,
        phone,
        password: encryptedPass,
        address,
        otp: await otpp,
      });
      await newUser.save();

      let id;
      if (role == 0) {
        const { DOB, gender } = req.body;
        const newPatient = new Patient({
          user_id: newUser._id,
          DOB,
          gender,
        });
        await newPatient.save();
        id = newPatient._id;
      } else if (role == 1) {
        const { nmc } = req.body;
        const hospitalDoctor = await hospitalModel.findOne(
          {
            doctors: { $elemMatch: { nmcNumber: nmc } },
          },
          {
            _id: 0,
            doctors: { $elemMatch: { nmcNumber: nmc }, hospitalName: 1 },
          }
        );
        if (!hospitalDoctor) {
          return res.status(400).json({
            msg: "No matching doctor found!",
          });
        }
        if (email !== hospitalDoctor.doctors[0].email)
          return res
            .status(400)
            .json({ msg: "NMC number and email does not match" });
        const newDoctor = new Doctor({
          user_id: newUser._id,
          hospital: hospitalDoctor.hospitalName,
          nmc,
          speciality: hospitalDoctor.doctors[0].speciality,
        });
        await newDoctor.save();
        id = newDoctor._id;
      } else {
        const labTechnician = await hospitalModel.findOne(
          {
            labTechnicians: { $elemMatch: { email: email } },
          },
          {
            _id: 0,
            labTechnicians: { $elemMatch: { email: email } },
            hospitalName: 1,
          }
        );

        if (!labTechnician) {
          return res.status(400).json({
            msg: "No matching lab technician found!",
          });
        }

        const newLabTechnician = new labTechnicianModel({
          user_id: newUser._id,
          hospital: labTechnician.hospitalName,
          speciality: labTechnician.labTechnicians[0].speciality,
        });
        await newLabTechnician.save();
        id = newLabTechnician._id;
      }
      const accessToken = createAccessToken({
        userId: newUser._id,
        role: role,
        id: id,
      });
      const refreshToken = createRefreshToken({
        userId: newUser._id,
        role: role,
        id: id,
      });

      return res.json({
        accessToken: accessToken,
        refreshToken: refreshToken,
        msg: "Registered successfully!",
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  login: async (req, res) => {
    try {
      const { email, password } = req.body;
      const user = await User.findOne({ email });
      if (!user) return res.status(400).json({ msg: "Incorrect Email!" });
      if (!(await bcrypt.compare(password, user.password))) {
        return res.status(400).json({ msg: "Wrong password!" });
      }
      let roledUser;
      if (user.role == 0) {
        roledUser = await Patient.findOne({ user_id: user._id });
      } else if (user.role == 1) {
        roledUser = await Doctor.findOne({ user_id: user._id });
      } else {
        roledUser = await labTechnicianModel.findOne({ user_id: user._id });
      }
      const finalUser = {
        user,
        roledUser,
      };
      //Login success so creating web tokens
      const accesstoken = createAccessToken({
        userId: user._id,
        role: user.role,
        id: roledUser._id,
      });
      const refreshtoken = createRefreshToken({
        userId: user._id,
        role: user.role,
        id: roledUser._id,
      });

      return res.json({
        user: finalUser,
        accessToken: accesstoken,
        refreshToken: refreshtoken,
      });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getUser: async (req, res) => {
    try {
      const { refreshToken } = req.body;
      var accesstoken;
      const u = jwt.verify(
        refreshToken,
        process.env.REFRESH_TOKEN,
        (err, user) => {
          if (err) {
            return null;
          }
          accesstoken = createAccessToken({
            userId: user.userId,
            role: user.role,
            id: user.id,
          });
          return user;
        }
      );
      if (!u) {
        return res.status(400).json({ msg: "Invalid authentication" });
      }
      const gotUser = { ...u, accesstoken };
      // console.log(gotUser);
      const user = await User.findOne({ _id: gotUser.userId });
      let roledUser;
      if (user.role == 0) {
        roledUser = await Patient.findOne({ user_id: gotUser.userId });
      } else if (user.role == 1) {
        roledUser = await Doctor.findOne({ user_id: gotUser.userId });
      } else {
        roledUser = await labTechnicianModel.findOne({
          user_id: gotUser.userId,
        });
      }
      const finalUser = {
        user,
        roledUser,
      };
      if (accesstoken) {
        return res.json({
          user: finalUser,
          accessToken: accesstoken,
        });
      } else {
        return res.json({
          user: finalUser,
        });
      }
    } catch (err) {
      // return res.status(500).json({ msg: err.message });
      console.log(err);
    }
  },
  addReminder: async (req, res) => {
    try {
      const { reminder, accessToken } = req.body;
      const user = jwt.verify(
        accessToken,
        process.env.ACCESS_TOKEN,
        (err, user) => {
          if (err) throw err;
          return user;
        }
      );
      const parsedReminder = JSON.parse(reminder);
      const patient = await Patient.findOne({ user_id: user.userId });
      var reminders = new Reminder({
        patientId: patient._id,
        name: parsedReminder.name,
        dosage: parsedReminder.dosage,
        doseTime: parsedReminder.doseTime,
      });
      await reminders.save();
      return res.json({
        msg: "Reminder added successfully!",
        id: reminders._id,
      });
    } catch (err) {
      console.log(err);
      return res.status(500).json({ msg: err.message });
    }
  },
  getReminder: async (req, res) => {
    try {
      const { accessToken, refreshToken } = req.body;
      const gotUser = jwt.verify(
        accessToken,
        process.env.ACCESS_TOKEN,
        (err, decoded) => {
          if (err) {
            const decod = jwt.verify(
              refreshToken,
              process.env.REFRESH_TOKEN,
              (err, user) => {
                if (err)
                  return res
                    .status(400)
                    .json({ msg: "Invalid authentication" });
                const accesstoken = (accesstoken = createAccessToken({
                  userId: user.userId,
                  role: user.role,
                  id: user.id,
                }));
                return { ...user, accesstoken };
              }
            );
            return decod;
          }
          return decoded;
        }
      );
      const patient = await Patient.findOne({ user_id: gotUser.userId });
      const reminders = await Reminder.find({ patientId: patient._id });
      return res.json(reminders);
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  delReminder: async (req, res) => {
    try {
      const { reminderId } = req.body;
      await Reminder.findByIdAndDelete(reminderId);
      return res.json({ msg: "Reminder deleted successfully!" });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  updateReminder: async (req, res) => {
    try {
      const { reminderId, doseIndex, changedPrevious } = req.body;
      var reminder = await Reminder.findById(reminderId);
      var doseTime = reminder.doseTime;
      if (reminder.doseTime.length - 1 == doseIndex) {
        doseTime = reminder.doseTime.map((value) => {
          value.isTaken = 0;
          return value;
        });
      } else {
        reminder.doseTime[doseIndex].isTaken = 1;
        if (changedPrevious) reminder.doseTime[doseIndex - 1].isTaken = -1;
        doseTime = reminder.doseTime;
      }
      await Reminder.findByIdAndUpdate(reminderId, { doseTime: doseTime });
    } catch (err) {
      console.log(err.message);
      return res.status(500).json({ msg: err.message });
    }
  },
  rating: async (req, res) => {
    try {
      const { rating, comment, accessToken, doctor_id, patientName } = req.body;
      console.log(patientName);

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

      const feedback_info = new feedback({
        comment: comment,
        rating: rating,
        firstName: patientName,
        patient_user_id: gotUser.userId,
        doctor_user_id: doctor_id,
        ptientName: patientName,
      });
      await feedback_info.save();
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },

  getFeedback: async (req, res) => {
    try {
      const { doctor_user_id } = req.body;
      var user, feedbacks;
      if (!doctor_user_id) {
        const { accessToken } = req.body;
        user = jwt.verify(
          accessToken,
          process.env.ACCESS_TOKEN,
          (err, user) => {
            if (err) console.log(err);
            return user;
          }
        );
        console.log(user);
        feedbacks = await feedback.find({ doctor_user_id: user.userId });
      } else {
        feedbacks = await feedback.find({ doctor_user_id: doctor_user_id });
      }
      console.log(feedbacks)
      return res.json(
        feedbacks,
      );
    } catch (error) {
      console.log(error.message);
      return res.status(500).json({ msg: error.message });
    }
  },
};

const createAccessToken = (user) => {
  return jwt.sign(user, process.env.ACCESS_TOKEN, { expiresIn: "12h" });
};

const createRefreshToken = (user) => {
  return jwt.sign(user, process.env.REFRESH_TOKEN, { expiresIn: "7d" });
};
module.exports = userCtrl;
