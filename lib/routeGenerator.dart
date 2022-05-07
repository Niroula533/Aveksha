// ignore_for_file: prefer_const_constructors
import 'package:aveksha/comp/patient_doctor_view.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:aveksha/controllers/userControl.dart';
import 'package:aveksha/patient/components/display_listOfDoctor.dart';
import 'package:aveksha/patient/components/display_specialities.dart';
import 'package:aveksha/patient/mainPage.dart';
import 'package:aveksha/patient/patientRegistrationPage.dart';
import 'package:aveksha/patient/search.dart';
import 'package:aveksha/doctor/doctorRegistrationPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:aveksha/firstPage.dart';
import 'package:aveksha/loginPage.dart';
import 'package:get/get.dart';
import 'doctor/main_page.dart';
import 'otpPage.dart';
import 'package:aveksha/labTechs/acceptedLabTech.dart';
import 'package:aveksha/appointment.dart';
import 'package:aveksha/labTechs/bloodTest.dart';
import 'package:aveksha/doctorviewappointment.dart';
import 'package:aveksha/labTechs/labTestAppointment.dart';
import 'package:aveksha/labTechs/labtech.dart';
import 'package:aveksha/labTechs/pdfBloodTest.dart';
import 'package:aveksha/labTechs/sugarTest.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    var emailForOTP;
    if (settings.name == '/otp') {
      emailForOTP = settings.arguments;
    }
    AppointmentDetails appointmentInfo;
    LabAppointmentDetails labAppInfo;
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/registration':
        return MaterialPageRoute(builder: (_) => FirstPage());
      case '/patientRegistration':
        return MaterialPageRoute(builder: (_) => PatientRegistrationPage());
      case '/doctorRegistration':
        return MaterialPageRoute(builder: (_) => DoctorRegistrationPage());
      case '/otp':
        // return MaterialPageRoute(builder: (_) => OtpPage(email: emailForOTP));
        return MaterialPageRoute(builder: (_) => OtpPage(email: emailForOTP));
      case '/patientMain':
        return MaterialPageRoute(builder: (_) => PatientMainPage());
      case '/doctorMain':
        return MaterialPageRoute(builder: (_) => DoctorMainPage());
      case '/appointment':
        AppointmentDet appointmentDetails =
            settings.arguments as AppointmentDet;
        return MaterialPageRoute(
            builder: (_) =>
                AppointmentRequest(appointmentDetails: appointmentDetails));
      case '/doctorviewappointment':
        appointmentInfo = settings.arguments as AppointmentDetails;
        return MaterialPageRoute(
            builder: (_) =>
                DoctorViewAppointment(appointmentInfo: appointmentInfo));
      case '/labAppointmentRequest':
        return MaterialPageRoute(builder: (_) => ReqLabAppointment());
      case '/labtech':
        labAppInfo = settings.arguments as LabAppointmentDetails;
        return MaterialPageRoute(
            builder: (_) => LabTechPage(labAppInfo: labAppInfo));
      case '/acceptedLabList':
        labAppInfo = settings.arguments as LabAppointmentDetails;
        return MaterialPageRoute(
            builder: (_) => AcceptedLabTech(labAppInfo: labAppInfo));
      case '/bloodTest':
        String pname = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => BloodTestLab(pname: pname));
      case '/sugarTest':
        String pname = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SugarTestLab(pname: pname));
      case '/pdfBloodTest':
        BloodTestData btdata = settings.arguments as BloodTestData;
        return MaterialPageRoute(builder: (_) => PdfBloodTest(btdata: btdata));
      case '/searchPage':
        Function updateIndex = settings.arguments as Function;
        return MaterialPageRoute(
            builder: (_) => PatientSearch(
                  updateIndex: updateIndex,
                ));
      case '/patientToOther':
        DocOrLab serviceProvider = settings.arguments as DocOrLab;
        return MaterialPageRoute(
            builder: (_) => PatientToDoctor(serviceProvider: serviceProvider));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        int isInitialized = Get.find<UserInfo>().role;
        print(isInitialized);
        if (isInitialized == 0) {
          return MaterialPageRoute(builder: (_) => PatientMainPage());
        } else if (isInitialized == 1) {
          return MaterialPageRoute(builder: (_) => DoctorMainPage());
         // needs to be changed to lab technician main page
        } else {
          return _errorRoute();
        }
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
