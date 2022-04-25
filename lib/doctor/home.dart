// ignore_for_file: prefer_const_constructors

import 'package:aveksha/doctor/components/appointmentReq.dart';
import 'package:aveksha/doctor/components/scheduledAppointments.dart';
import 'package:aveksha/pdfBloodTest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../controllers/userControl.dart';
import '../patient/components/tab_component.dart';

class DoctorHome extends StatefulWidget {
  final Function logout;
  DoctorHome({Key? key, required this.logout}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  bool appointmentActive = true;
  bool scheduleActive = false;

  List<Widget> appointmentRequests = [
    AppointmentRequest(
        patientName: "Mr. Ayush", dateTime: "30-Apr 2022, 04:30"),
    AppointmentRequest(
        patientName: "Mr. Ankush", dateTime: "20-Apr 2022, 01:30")
  ];
  List<Widget> scheduledAppointments = [
    ScheduledAppoinements(
        patientName: "Mr. Jackie", dateTime: "14-Apr 2022, 11:30"),
    ScheduledAppoinements(
        patientName: "Mr. Sushant", dateTime: "13-Apr 2022, 10:00"),
  ];

  updateTab(index) {
    if (index == 0) {
      setState(() {
        appointmentActive = true;
        scheduleActive = false;
      });
    } else {
      setState(() {
        scheduleActive = true;
        appointmentActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String pfname =
        Get.find<UserInfo>().firstName + ' ' + Get.find<UserInfo>().lastName;

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE1EBF1),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: SingleChildScrollView(
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
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                      name: "APPOINTMENTS",
                      isActive: appointmentActive,
                      heightRatio: 0.07,
                      widthRatio: 0.375,
                    ),
                    onTap: () => updateTab(0),
                  ),
                  GestureDetector(
                    child: TabComponent(
                      name: "SCHEDULES",
                      isActive: scheduleActive,
                      heightRatio: 0.07,
                      widthRatio: 0.35,
                    ),
                    onTap: () => updateTab(1),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              if (appointmentActive)
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Appointment Requests',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:
                              200, // (250 - 50) where 50 units for other widgets
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            shrinkWrap: true,
                            children: appointmentRequests,
                          )),
                      // ...appointments,
                      Divider(
                        thickness: 2,
                      ),
                      Text('Previous Interaction',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:
                              200, // (250 - 50) where 50 units for other widgets
                          child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              shrinkWrap: true,
                              children: scheduledAppointments)),
                      // ...prevAppointments
                    ],
                  ),
                ),
              if (scheduleActive)
                Container(
                    child: ElevatedButton(
                  child: Text('Request Appointment'),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/appointment', arguments: pfname);
                  },
                )),
            ],
          ),
        ),
      ),
    );
  }
}
