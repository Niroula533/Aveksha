import 'package:flutter/material.dart';
import 'home.dart';
import '../navigation_bar.dart';

class PatientMainPage extends StatefulWidget {
  PatientMainPage({Key? key}) : super(key: key);

  @override
  State<PatientMainPage> createState() => _PatientMainPageState();
}

class _PatientMainPageState extends State<PatientMainPage> {
  int _currentIndex = 0;

  updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  goToLogin() {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic>route) => false);
  }

  

  @override
  Widget build(BuildContext context) {
    List pages = [
    PatientHome(logout: goToLogin),
    Center(
      child: Text("Search"),
    ),
    Center(
      child: Text("Message"),
    ),
    Center(
      child: Text("MedFeed"),
    )
  ];
    return MaterialApp(
      home: Scaffold(
        body: pages[_currentIndex],
        extendBody: true,
        bottomNavigationBar: NavBar(updateIndex: updateIndex),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}