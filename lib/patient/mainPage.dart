import 'package:aveksha/apis/flutter_notifications.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:aveksha/patient/components/display_listOfDoctor.dart';
import 'package:aveksha/patient/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';
import '../comp/navigation_bar.dart';

class PatientMainPage extends StatefulWidget {
  PatientMainPage({Key? key}) : super(key: key);

  @override
  State<PatientMainPage> createState() => _PatientMainPageState();
}

class _PatientMainPageState extends State<PatientMainPage> {
  int _currentIndex = 0;
  String? _specialization = "General Physician";
  var allDocLab = Get.put(ListOfDoctorsAndLabtech());

  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.of(context)
      .pushNamedAndRemoveUntil('/patientMain', (Route<dynamic> route) => false);

  updateIndex({required int index, String? specialization}) async {
    await allDocLab.getDoctors();
    setState(() {
      if (specialization != null) {
        _specialization = specialization;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => Speciality_Doctor(
                    specialization: _specialization!,
                    isDoctor: true,
                  )),
        );
      } else {
        _currentIndex = index;
      }
    });
  }

  goToLogin() {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      PatientHome(logout: goToLogin),
      PatientSearch(
        updateIndex: updateIndex,
      ),
      Center(
        child: Text("Message"),
      )
      // Center(
      //   child: Text("MedFeed"),
      // )
    ];
    return Scaffold(
      body: pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: NavBar(updateIndex: updateIndex),
    );
  }
}
