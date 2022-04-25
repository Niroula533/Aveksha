import 'package:aveksha/apis/getNdeleteReminders.dart';
import 'package:aveksha/controllers/hrControl.dart';
import 'package:aveksha/controllers/reminderControl.dart';
import 'package:aveksha/controllers/userControl.dart';
import 'package:aveksha/loginPage.dart';
import 'package:aveksha/models/medicine_model.dart';
import 'package:aveksha/patient/components/appointments.dart';
import 'package:aveksha/patient/components/hr_component.dart';
import 'package:aveksha/patient/components/prevAppointment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import './components/tab_component.dart';
import 'components/med_component.dart';
import 'components/reminder_component.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class PatientHome extends StatefulWidget {
  final Function logout;
  PatientHome({Key? key, required this.logout}) : super(key: key);

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final allMedicine = Get.put(AllReminders());
  final allHr = Get.put(AllHR());
  bool play = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Widget> appointments = [
    DoctorAppointment(
        doctorName: 'A',
        speciality: 'Pediatrician',
        appointmentDate: 'TODAY',
        appointmentTime: '01:30 PM'),
    DoctorAppointment(
        doctorName: 'B',
        speciality: 'Physician',
        appointmentDate: 'JAN 28',
        appointmentTime: '12:00 PM'),
  ];
  List<Widget> prevAppointments = [
    PrevDoctorAppointment(doctorName: 'A', speciality: 'Pediatrician')
  ];

  setPlay(bool playValue) {
    setState(() {
      play = playValue;
    });
  }

  getPlay() {
    return play;
  }

  bool medActive = true;
  bool ehrActive = false;
  bool docActive = false;

  updateTab(index) {
    if (index == 0) {
      setState(() {
        medActive = true;
        ehrActive = false;
        docActive = false;
      });
    } else if (index == 1) {
      setState(() {
        ehrActive = true;
        medActive = false;
        docActive = false;
      });
    } else {
      setState(() {
        docActive = true;
        medActive = false;
        ehrActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem> menuItems = [
      PopupMenuItem(child: Text("Edit Profile")),
      PopupMenuItem(
          child: TextButton(
        child: Text("Sign Out"),
        onPressed: () async {
          final storage = FlutterSecureStorage();
          await storage.deleteAll();
          // Navigator.of(context).pushReplacementNamed('/login');
          await widget.logout();
        },
      ))
    ];

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            color: const Color(0xFFE1EBF1),
            padding: EdgeInsets.symmetric(
                vertical: height * 0.05, horizontal: width * 0.04),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: height * 0.095,
                            width: height * 0.095,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "HELLO END",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1
                                    ..color = Colors.black,
                                ),
                              ),
                              Text("GOOD MORNING!"),
                            ],
                          ),
                        )
                      ],
                    ),
                    PopupMenuButton(itemBuilder: (context) => [...menuItems])
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: const [
                //     Text("Sushant Adhikari, 21"),
                //     Text("Dhulikhel, Kavre"),
                //     Text("sushantadhikari2001@gmail.com"),
                //     Text("+977 9815167761"),
                //   ],
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.04,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: TabComponent(
                        name: "MED",
                        isActive: medActive,
                        heightRatio: 0.06,
                        widthRatio: 0.25,
                      ),
                      onTap: () => updateTab(0),
                    ),
                    GestureDetector(
                      child: TabComponent(
                        name: "HR",
                        isActive: ehrActive,
                        heightRatio: 0.06,
                        widthRatio: 0.25,
                      ),
                      onTap: () => updateTab(1),
                    ),
                    GestureDetector(
                      child: TabComponent(
                        name: "DOC",
                        isActive: docActive,
                        heightRatio: 0.06,
                        widthRatio: 0.25,
                      ),
                      onTap: () => updateTab(2),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                if (medActive)
                  Expanded(
                    child: GetX<AllReminders>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.allMedicine.length,
                        itemBuilder: (context, index) {
                          return controller.allMedicine[index];
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                  ),
                if (docActive)
                  Column(
                    children: [
                      Text('Appontements'),
                      SizedBox(
                          height:
                              200, // (250 - 50) where 50 units for other widgets
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            shrinkWrap: true,
                            children: appointments,
                          )),
                      // ...appointments,
                      Divider(),
                      Text('Previous Interactions'),
                      SizedBox(
                          height:
                              150, // (250 - 50) where 50 units for other widgets
                          child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              shrinkWrap: true,
                              children: prevAppointments)),
                      // ...prevAppointments
                    ],
                  ),
                if (ehrActive)
                  Expanded(
                    child: GetX<AllHR>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.allHr.length,
                        itemBuilder: (context, index) {
                          return controller.allHr[index];
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                  ),
              ],
            ),
          ),
          if (!docActive)
            Positioned(
              top: height * 0.775,
              left: width * 0.85,
              child: FloatingActionButton(
                onPressed: () async {
                  if (medActive) {
                    await addReminder(context);
                  } else {
                    await addHealthRecords(context);
                  }
                },
                backgroundColor: Color(0xFF60BBFE).withOpacity(0.75),
                child: Icon(Icons.add, color: Colors.white, size: 32),
              ),
            )
        ],
      ),
      onTap: () {
        // setPlay(false);
        Get.find<AllReminders>().play = false;
      },
    );
  }
}
