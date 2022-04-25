import 'package:aveksha/patient/mainPage.dart';
import 'package:aveksha/patient/patientRegistrationPage.dart';
import 'package:aveksha/doctor/doctorRegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:aveksha/firstPage.dart';
import 'package:aveksha/loginPage.dart';
import 'doctor/main_page.dart';
import 'otpPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    var emailForOTP;
    if (settings.name == '/otp') {
      emailForOTP = settings.arguments;
    }
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
