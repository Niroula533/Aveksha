import 'package:aveksha/patient/search.dart';
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

  List pages = [
    PatientHome(),
    PatientSearch(),
    // Center(
    //   child: Text("Search"),
    // ),
    Center(
      child: Text("Message"),
    ),
    Center(
      child: Text("MedFeed"),
    )
  ];

  @override
  Widget build(BuildContext context) {
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