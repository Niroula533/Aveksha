// ignore_for_file: prefer_const_constructors, prefer_final_fields, no_logic_in_create_state, prefer_const_literals_to_create_immutables

import 'package:aveksha/labTechs/labTestAppointment.dart';
import 'package:flutter/material.dart';

class LabTechPage extends StatefulWidget {
  LabAppointmentDetails labAppInfo;
  LabTechPage({Key? key, required this.labAppInfo}) : super(key: key);
  @override
  State<LabTechPage> createState() => _LabTechPageState(
      labAppInfo.pname, labAppInfo.pdate, labAppInfo.ptime, labAppInfo.pTest);
}

class _LabTechPageState extends State<LabTechPage> {
  String pname;
  String pTest;
  TimeOfDay ptime;
  String pdate;
  _LabTechPageState(this.pname, this.pdate, this.ptime, this.pTest) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/registration');
              },
              child: Container(
                  // child: Image.asset('image/aveksha_logo.png'),
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Image.asset('images/aveksha_logo.png',
                      height: 100, width: 200),
                  padding: EdgeInsets.all(5.0)),
            )),
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 217, 235, 233),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.check_circle),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/acceptedLabList', 
                            arguments: LabAppointmentDetails(pname, pdate, ptime, pTest));
                          },
                        ), // icon-1
                        IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            //remove request
                          },
                        ), // icon-2
                      ],
                    ),
                    title: Text(pname),
                    subtitle: Text('Requested for $pTest'),
                    onTap: () {},
                  ),
                ],
              ),
            )));
  }
}
