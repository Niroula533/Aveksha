// ignore_for_file: prefer_const_constructors

import 'package:aveksha/acceptedLabTech.dart';
import 'package:aveksha/appointment.dart';
import 'package:aveksha/bloodTest.dart';
import 'package:aveksha/doctorviewappointment.dart';
import 'package:aveksha/labTestAppointment.dart';
import 'package:aveksha/labtech.dart';
import 'package:aveksha/patientRegistrationPage.dart';
import 'package:aveksha/doctorRegistrationPage.dart';
import 'package:aveksha/pdfBloodTest.dart';
import 'package:flutter/material.dart';
import 'package:aveksha/main.dart';
import 'package:aveksha/loginPage.dart';

import 'sugarTest.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
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
      case '/appointment':
        return MaterialPageRoute(builder: (_) => AppointmentRequest());
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
        return MaterialPageRoute(
            builder: (_) => BloodTestLab(pname: pname));
      case '/sugarTest':
        String pname = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => SugarTestLab(pname: pname));
      case '/pdfBloodTest':
        return MaterialPageRoute(builder: (_) => PdfBloodTest());
      
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
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
