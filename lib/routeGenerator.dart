import 'package:aveksha/patient/components/display_listOfDoctor.dart';
import 'package:aveksha/patient/components/display_specialities.dart';
import 'package:aveksha/patient/mainPage.dart';
import 'package:aveksha/patient/search.dart';
import 'package:aveksha/patientRegistrationPage.dart';
import 'package:aveksha/doctorRegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:aveksha/main.dart';
import 'package:aveksha/loginPage.dart';
import 'otpPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // var emailForOTP;
    // if (settings.name == '/otp') {
    //   emailForOTP = settings.arguments;
    // }
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
        return MaterialPageRoute(builder: (_) => OtpPage());
      case '/patientMain':
        return MaterialPageRoute(builder: (_) => PatientMainPage());
      case '/searchPage':
        return MaterialPageRoute(builder: (_) => PatientSearch());
      case '/display_listOfDoctor':
        return MaterialPageRoute(builder: (_) => Display_Doctor(specialization: '',));
      case '/display_specialities':
        return MaterialPageRoute(builder: (_) => Specialities());


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
