import 'package:aveksha/doctor/feedBackPage.dart';
import 'package:flutter/material.dart';
import './home.dart';
import './doc_navigation_bar.dart';

class DoctorMainPage extends StatefulWidget {
  DoctorMainPage({Key? key}) : super(key: key);

  @override
  State<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  int _currentIndex = 0;

  updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  goToLogin() {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      DoctorHome(logout: goToLogin),
      Center(
        child: Text("Message"),
      ),
      FeedBackPage(logout: goToLogin),
    ];
    return Scaffold(
        body: pages[_currentIndex],
        extendBody: true,
        bottomNavigationBar: NavBar(updateIndex: updateIndex),
      );
  }
}
