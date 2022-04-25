const User = require("../models/userModel");
const Patient = require("../models/patientModel");
const Doctor = require("../models/doctorModel");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const hospitalModel = require("../models/hospitalModel");
const labTechnicianModel = require("../models/labTechnicianModel");
const Reminder = require("../models/reminderModel");
require("dotenv").config();

var generateOtp = async (email) => {
  var generatedOtp = Math.floor(100000 + Math.random() * 900000);
  generatedOtp = parseInt(generatedOtp);
  console.log(generatedOtp);

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
        const nmc_email = await hospitalModel.findOne(
          {
            doctors: { $elemMatch: { nmcNumber: nmc } },
          },
          { _id: 0, doctors: { $elemMatch: { nmcNumber: nmc } } }
        );
        console.log(nmc_email.doctors[0]);
        if (!nmc_email) {
          return res.status(400).json({
            msg: "No matching doctor found!",
          });
        }
        if (email !== nmc_email.doctors[0].email)
          return res
            .status(400)
            .json({ msg: "NMC number and email does not match" });
        const newDoctor = new Doctor({
          user_id: newUser._id,
          nmc,
        });
        await newDoctor.save();
        id = newDoctor._id;
      } else {
        const labTechnician = await hospitalModel.findOne({
          labTechnicians: { $elemMatch: { email: email } },
        });

        if (!labTechnician) {
          return res.status(400).json({
            msg: "No matching lab technician found!",
          });
        }

        const newLabTechnician = new labTechnicianModel({
          user_id: newUser._id,
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
            return res.status(400).json({ msg: "Invalid authentication" });
          }
          accesstoken = createAccessToken({
            userId: user.userId,
            role: user.role,
            id: user.id,
          });

          return user;
        }
      );
      const gotUser = { ...u, accesstoken };
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
      }else{
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
        id: reminder._id,
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
                const accesstoken = createAccessToken(user);
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
};

const createAccessToken = (user) => {
  return jwt.sign(user, process.env.ACCESS_TOKEN, { expiresIn: "12h" });
};

const createRefreshToken = (user) => {
  return jwt.sign(user, process.env.REFRESH_TOKEN, { expiresIn: "7d" });
};
module.exports = userCtrl;
