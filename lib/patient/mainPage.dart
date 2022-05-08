import 'package:aveksha/apis/flutter_notifications.dart';
import 'package:aveksha/comp/meeting.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:aveksha/controllers/feedbackControl.dart';
import 'package:aveksha/controllers/reminderControl.dart';
import 'package:aveksha/controllers/userControl.dart';
import 'package:aveksha/patient/components/display_listOfDoctor.dart';
import 'package:aveksha/patient/search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  var allDocLab = Get.put(ListOfDoctorsAndLabtech());

  @override
  void initState() {
    super.initState();
    Get.put(ListofAppointments());
    Get.put(ListOfFeedbacks());
    NotificationApi.init(initScheduled: true);
    // listenNotification();
  }

  // void listenNotifications() =>
  //     NotificationApi.onNotifications.stream.listen(onClickedNotification);

  // void onClickedNotification(String? payload) => Navigator.of(context)
  //     .pushNamedAndRemoveUntil('/patientMain', (Route<dynamic> route) => false);

  updateIndex(
      {bool? isDoctor, required int index, String? specialization}) async {
    await allDocLab.getDoctors();
    setState(() {
      if (specialization != null) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => Speciality_Doctor(
                    specialization: specialization,
                    isDoctor: isDoctor!,
                  )),
        );
      } else {
        _currentIndex = index;
      }
    });
  }

  goToLogin() async {
    try {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(Get.find<UserInfo>().phone.toString());
    } catch (e) {
      print(e);
    }
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
      Meeting()
    ];
    return Scaffold(
      body: pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: NavBar(updateIndex: updateIndex),
    );
  }
}
