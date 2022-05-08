// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:aveksha/controllers/userControl.dart';
import 'package:aveksha/doctor/components/scheduleLab.dart';
import 'package:aveksha/doctor/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/doctorControl.dart';
import '../patient/components/tab_component.dart';
import 'components/scheduleDoctor.dart';

class DoctorHome extends StatefulWidget {
  final Function logout;
  DoctorHome({Key? key, required this.logout}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  bool appointmentActive = true;
  bool scheduleActive = false;
  List appointmentRequests = [];
  int count = 0;

  void getAppointment() async {
    var storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: "accessToken");
    await Get.find<ListofAppointments>().getAppointments(
        accessToken: accessToken, role: Get.find<UserInfo>().role);

    appointmentRequests = [Get.find<ListofAppointments>().appointments];
  }

  @override
  void initState() {
    Get.put(UserInfo());
    Get.put(ListofAppointments());
    Get.put(ListOfDoctorsAndLabtech());
    getAppointment();
    super.initState();
  }

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

  returnTime(time) {
    TimeOfDay _time = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
    return _time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay now = TimeOfDay.now();
    bool morning = now.hour > 4 && now.hour < 12;
    bool afternoon = now.hour >= 12 && now.hour < 18;
    bool evening = now.hour >= 18 && now.hour < 22;
    String gretting = morning
        ? "Morning"
        : afternoon
            ? "Afternoon"
            : evening
                ? "Evening"
                : "Night";

    List<PopupMenuItem> menuItems = [
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
      resizeToAvoidBottomInset: false,
      body: Container(
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
                            "HELLO " + Get.find<UserInfo>().firstName,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1
                                ..color = Colors.black,
                            ),
                          ),
                          Text("GOOD $gretting!"),
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      thickness: 3,
                    ),
                    Text(
                      'Appointment Requests',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GetX<ListofAppointments>(builder: (controller) {
                      print(controller);
                      return ListView.builder(
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            count = 0;
                          }
                          if (controller.appointments[index].status ==
                              'Pending') {
                            return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ListTile(
                                  leading: Icon(Icons.circle),
                                  trailing: Wrap(
                                    spacing: 12, // space between two icons
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.check_outlined,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          Get.find<ListofAppointments>()
                                              .updateAppointments(
                                            id: controller
                                                .appointments[index].id,
                                            status: "Active",
                                          );
                                          Get.offAll(() => DoctorMainPage());
                                        },
                                      ), // icon-1
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          Get.find<ListofAppointments>()
                                              .updateAppointments(
                                            id: controller
                                                .appointments[index].id,
                                            status: "Rejected",
                                          );
                                          Get.offAll(() => DoctorMainPage());
                                        },
                                      ), // icon-2
                                    ],
                                  ),
                                  title: Text(
                                    controller.appointments[index].patient_Name,
                                  ),
                                  subtitle: Text(DateFormat('MMM d, yyyy')
                                          .format(DateTime.parse(controller
                                              .appointments[index].date)) +
                                      ', ' +
                                      returnTime(
                                          controller.appointments[index].time)),
                                ));
                          } else {
                            count = count + 1;
                            if (count == controller.appointments.length) {
                              return Text(
                                'No Requests',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              );
                            }
                            return Container(
                              height: 0,
                              width: 0,
                            );
                          }
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                    Text(
                      'Scheduled Appointments',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GetX<ListofAppointments>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          if (controller.appointments[index].status ==
                              'Active') {
                            return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ListTile(
                                  leading: Icon(Icons.circle),
                                  title: Text(
                                    controller.appointments[index].patient_Name,
                                  ),
                                  subtitle: Text(DateFormat('MMM d, yyyy')
                                          .format(DateTime.parse(controller
                                              .appointments[index].date)) +
                                      ', ' +
                                      returnTime(
                                          controller.appointments[index].time)),
                                ));
                          } else {
                            return Container(
                              height: 0,
                            );
                          }
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                  ],
                ),
              ),
            if (scheduleActive && Get.find<UserInfo>().role == 1)
              ScheduleAppointmentDoctor(),
            if (scheduleActive && Get.find<UserInfo>().role == 2)
              ScheduleAppointmentLab()
          ],
        ),
      ),
    );
  }
}
