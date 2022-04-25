const HR = require("../models/hrModel");
const jwt = require("jsonwebtoken");
require("dotenv").config();

const hrCtrl = {
  addHR: async (req, res) => {
    try {
      const { title, url, date, accessToken } = req.body;
      const user = jwt.verify(accessToken, process.env.ACCESS_TOKEN);
      const newHR = new HR({
        date: date,
        title: title,
        url: url,
        patientId: user.id,
      });
      await newHR.save();
      return res.json({ id: newHR._id });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  getHrs: async (req, res) => {
    try {
      const { accessToken } = req.body;
      const user = jwt.verify(accessToken, process.env.ACCESS_TOKEN);
      const allHRS = await HR.find({ patientId: user.id }).sort({ date: 1 });
      console.log(allHRS);
      if (allHRS) {
        return res.json({ hr: allHRS });
      }
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
  delHr: async (req, res) => {
    try {
      const { accessToken } = req.body;
      const user = jwt.verify(accessToken, process.env.ACCESS_TOKEN);
      const allHRS = await HR.findOneAndDelete({ patientId: user.id });
      return res.json({msg: "Successfull"});
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },
};

module.exports = hrCtrl;
