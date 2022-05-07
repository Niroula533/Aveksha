import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            title: Container(
                // child: Image.asset('image/aveksha_logo.png'),
                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Image.asset('images/aveksha_logo.png',
                    height: 100, width: 200),
                padding: EdgeInsets.all(5.0))),
        body: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 228, 234, 235),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'SELECT USER TYPE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/doctorRegistration');
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
                      height: 100,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(206, 214, 208, 208),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: Text('Health Professional',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/patientRegistration');
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
                      height: 100,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(206, 214, 208, 208),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: Text('Common User',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                      )),
                ),
              ],
            )));
  }
}
