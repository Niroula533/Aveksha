const User = require("../models/userModel");
const Patient = require("../models/patientModel");
const Doctor = require("../models/doctorModel");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const hospitalModel = require("../models/hospitalModel");
const labTechnicianModel = require("../models/labTechnicianModel");
require("dotenv").config();

const userCtrl = {
  // home:async(req,res)=>
  // {
  //   var generateOtp = async () => {
  //     var generatedOtp = Math.random();
  //     generatedOtp = generatedOtp * 1000000;
  //     generatedOtp = parseInt(generatedOtp);
  //     console.log(generatedOtp);
  //     return generatedOtp;
  //   };

  //   var otpp = generateOtp();

  // },

  otpCheck: async (req, res) => {
    try {
      const { otp, email } = req.body;

      const user = await User.findOne({ email, otp });
      if (user) {
        await User.updateOne({ email, otp }, { $set: { confirmed: true } });
        return res.status(200).json({ msg: "Account is verified" });
      } else {
        return res.status(500).json({ msg: "error , invalid token code" });
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

      var generateOtp = async () => {
        var generatedOtp = Math.floor(100000 + Math.random() * 900000);
        generatedOtp = generatedOtp * 1000000;
        generatedOtp = parseInt(generatedOtp);
        console.log(generatedOtp);
        return generatedOtp;
      };
      var otpp = generateOtp();

      // otp = otpp;

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
        to: req.body.email,
        subject: "Otp for registration is: ",
        html:
          "<h3>OTP for account verification is </h3>" +
          `<h1 style='font-weight:bold;'> 
          ${await otpp} 
          </h1>`, // html body
      };

      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          return console.log(error);
        }
        console.log("Message sent: %s", info.messageId);
        console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));

        res.render("otp");
      });
      const { otp } = req.body;
      console.log(otpp);
      if (req.body.otp !== otp)
        return res.status(400).json({ msg: "Invalid Otp code" });
      else {
        console.log("correct otp");

        // confirmed = 1;
      }

      let id;
      if (role == 0) {
        const { DOB } = req.body;
        const newPatient = new Patient({
          user_id: newUser._id,
          DOB,
        });
        await newPatient.save();
        id = newPatient._id;
      } else if (role == 1) {
        const { nmc } = req.body;
        const nmc_email = await hospitalModel.findOne(
          { doctors: { nmc: nmc } },
          { _id: 0, doctors: { email: 1 } }
        );
        if (email !== nmc_email)
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
        const newLabTechnician = new labTechnicianModel({
          user_id: newUser._id,
        });
        await newLabTechnician.save();
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

      res.json({
        accessToken,
        refreshToken,
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
      let id;
      if (role == 0) {
        id = await Patient.findOne({ user_id: user._id }, { _id: 1 });
      } else if (role == 1) {
        id = await Doctor.findOne({ user_id: user._id }, { _id: 1 });
      } else {
        id = await labTechnicianModel.findOne(
          { user_id: user._id },
          { _id: 1 }
        );
      }

      //Login success so creating web tokens
      const accesstoken = createAccessToken({
        userId: user._id,
        role: user.role,
        id: id,
      });
      const refreshtoken = createRefreshToken({
        userId: user._id,
        role: user.role,
        id: id,
      });

      res.json({
        accesstoken: accesstoken,
        refreshtoken: refreshtoken,
        role: user.role,
      });
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
