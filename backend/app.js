require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const fileUpload = require("express-fileupload");
const userRoute = require("./routes/userRoute");
const hospitalModel = require("./models/hospitalModel");

const app = express();

app.use(
  cors({
    credential: true,
    origin: "*",
  })
);

app.use(cookieParser());
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ limit: "10mb", extended: true }));
app.use(fileUpload({ useTempFiles: true }));

const PORT = process.env.PORT || 5000;
const URI = process.env.URI;
mongoose.connect(URI, (err) => {
  if (err) throw err;
  console.log("Connected to MONGODB");
});

app.get("/", (req, res) => {
  res.json({ msg: "Dashboard!" });
});
app.post('/hospital', async(req,res)=>{
  const {labTechnicians, doctors, hospitalName} = req.body;
  const hospital = new hospitalModel({
    hospitalName: hospitalName,
    labTechnicians: labTechnicians,
    doctors: doctors
  });
  await hospital.save();
  res.json(hospital)
})

app.use("/user", userRoute);

app.listen(PORT, () => {
  console.log(`Running on server ${PORT}`);
});
