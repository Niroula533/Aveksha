import 'package:aveksha/comp/meeting.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:aveksha/controllers/feedbackControl.dart';
import 'package:aveksha/doctor/feedBackPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userControl.dart';
import './home.dart';
import './doc_navigation_bar.dart';

class DoctorMainPage extends StatefulWidget {
  DoctorMainPage({Key? key}) : super(key: key);

  @override
  State<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  
  @override
  void initState() {
    super.initState();
    // Get.put(ListofAppointments());
    Get.put(ListOfFeedbacks());
    // listenNotification();
  }
  int _currentIndex = 0;

  updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  goToLogin() async {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(Get.find<UserInfo>().phone.toString());
    return Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      DoctorHome(logout: goToLogin),
      Meeting(),
      FeedBackPage(logout: goToLogin),
    ];
    return Scaffold(
      body: _currentIndex==1?new Meeting(): pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: NavBar(updateIndex: updateIndex),
    );
  }
}
