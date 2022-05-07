// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:aveksha/comp/navigation_bar.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import '../controllers/userControl.dart';
import '../patient/components/tab_component.dart';

class AppointmentDet {
  String patientName;
  var docID;

  AppointmentDet(this.patientName, this.docID);
}

class PatientToDoctor extends StatefulWidget {
  final DocOrLab serviceProvider;
  PatientToDoctor({Key? key, required this.serviceProvider}) : super(key: key);

  @override
  State<PatientToDoctor> createState() => _PatientToDoctorState();
}

class _PatientToDoctorState extends State<PatientToDoctor> {
  bool feedbackActive = false;
  bool scheduleActive = true;
  final listAppointments = Get.find<ListofAppointments>().appointments;

  @override
  void initState() {
    Get.find<ListofAppointments>().getAppointments(
        id: widget.serviceProvider.id, role: widget.serviceProvider.role);
    super.initState();
  }

  viewSlot(time, hour) {
    int _hour = hour.toInt();
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
    TimeOfDay _endTime = _startTime.replacing(
        hour: _startTime.hour + _hour, minute: _startTime.minute);

    return _startTime.format(context) + ' - ' + _endTime.format(context);
    // print(_startTime);
    // print(_endTime);
  }

  updateTab(index) {
    if (index == 0) {
      setState(() {
        feedbackActive = false;
        scheduleActive = true;
      });
    } else {
      setState(() {
        scheduleActive = false;
        feedbackActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String docOrlabName = widget.serviceProvider.firstName;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var count = 0;

    String docId = widget.serviceProvider.id;
    String patientName =
        Get.find<UserInfo>().firstName + ' ' + Get.find<UserInfo>().lastName;
    AppointmentDet appdetails = AppointmentDet(patientName, docId);

    return Scaffold(
      body: Container(
        color: const Color(0xFFE1EBF1),
        padding: EdgeInsets.symmetric(
            vertical: height * 0.05, horizontal: width * 0.04),
        child: Column(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.serviceProvider.role == 1
                            ? "Dr. $docOrlabName"
                            : docOrlabName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        widget.serviceProvider.speciality.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: TabComponent(
                    name: "SCHEDULES",
                    isActive: scheduleActive,
                    heightRatio: 0.07,
                    widthRatio: 0.375,
                  ),
                  onTap: () => updateTab(0),
                ),
                GestureDetector(
                  child: TabComponent(
                    name: "FEEDBACKS",
                    isActive: feedbackActive,
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
            if (feedbackActive) Container(),
            if (scheduleActive)
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      thickness: 7,
                    ),
                    Row(
                      children: [
                        Text(
                            DateFormat('EEEE')
                                .format(DateTime.now().add(Duration(days: 1))),
                            style: TextStyle(fontSize: 18)),
                        Text(
                            ', ' +
                                DateFormat('MMM dd').format(
                                    DateTime.now().add(Duration(days: 1))),
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                    GetX<ListofAppointments>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          if (DateTime.now().isBefore(DateTime.parse(
                                  controller.appointments[index].date)) &&
                              DateTime.parse(
                                      controller.appointments[index].date)
                                  .isBefore(
                                      DateTime.now().add(Duration(days: 7)))) {
                            if (DateFormat('EEEE').format(DateTime.parse(
                                    controller.appointments[index].date)) ==
                                DateFormat('EEEE').format(
                                    DateTime.now().add(Duration(days: 1)))) {
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 156, 31, 22),
                                        borderRadius: BorderRadius.circular(4),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Text(
                                        viewSlot(
                                            controller.appointments[index].time,
                                            controller
                                                .appointments[index].hour),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                    Divider(
                      thickness: 3,
                    ),
                    Row(
                      children: [
                        Text(
                            DateFormat('EEEE')
                                .format(DateTime.now().add(Duration(days: 2))),
                            style: TextStyle(fontSize: 18)),
                        Text(
                            ', ' +
                                DateFormat('MMM dd').format(
                                    DateTime.now().add(Duration(days: 2))),
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                    GetX<ListofAppointments>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          if (DateTime.now().isBefore(DateTime.parse(
                                  controller.appointments[index].date)) &&
                              DateTime.parse(
                                      controller.appointments[index].date)
                                  .isBefore(
                                      DateTime.now().add(Duration(days: 7)))) {
                            if (DateFormat('EEEE').format(DateTime.parse(
                                    controller.appointments[index].date)) ==
                                DateFormat('EEEE').format(
                                    DateTime.now().add(Duration(days: 2)))) {
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 156, 31, 22),
                                        borderRadius: BorderRadius.circular(4),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Text(
                                        viewSlot(
                                            controller.appointments[index].time,
                                            controller
                                                .appointments[index].hour),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                    Divider(
                      thickness: 3,
                    ),
                    Row(
                      children: [
                        Text(
                            DateFormat('EEEE')
                                .format(DateTime.now().add(Duration(days: 3))),
                            style: TextStyle(fontSize: 18)),
                        Text(
                            ', ' +
                                DateFormat('MMM dd').format(
                                    DateTime.now().add(Duration(days: 3))),
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                    GetX<ListofAppointments>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          if (DateTime.now().isBefore(DateTime.parse(
                                  controller.appointments[index].date)) &&
                              DateTime.parse(
                                      controller.appointments[index].date)
                                  .isBefore(
                                      DateTime.now().add(Duration(days: 7)))) {
                            if (DateFormat('EEEE').format(DateTime.parse(
                                    controller.appointments[index].date)) ==
                                DateFormat('EEEE').format(
                                    DateTime.now().add(Duration(days: 3)))) {
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 156, 31, 22),
                                        borderRadius: BorderRadius.circular(4),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Text(
                                        viewSlot(
                                            controller.appointments[index].time,
                                            controller
                                                .appointments[index].hour),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                    Divider(
                      thickness: 3,
                    ),
                    Row(
                      children: [
                        Text(
                            DateFormat('EEEE')
                                .format(DateTime.now().add(Duration(days: 4))),
                            style: TextStyle(fontSize: 18)),
                        Text(
                            ', ' +
                                DateFormat('MMM dd').format(
                                    DateTime.now().add(Duration(days: 4))),
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                    GetX<ListofAppointments>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.appointments.length,
                        itemBuilder: (context, index) {
                          if (DateTime.now().isBefore(DateTime.parse(
                                  controller.appointments[index].date)) &&
                              DateTime.parse(
                                      controller.appointments[index].date)
                                  .isBefore(
                                      DateTime.now().add(Duration(days: 7)))) {
                            if (DateFormat('EEEE').format(DateTime.parse(
                                    controller.appointments[index].date)) ==
                                DateFormat('EEEE').format(
                                    DateTime.now().add(Duration(days: 4)))) {
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 156, 31, 22),
                                        borderRadius: BorderRadius.circular(4),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Text(
                                        viewSlot(
                                            controller.appointments[index].time,
                                            controller
                                                .appointments[index].hour),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                    Divider(
                      thickness: 7,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(2.5)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF60BBFE)),
                          ),
                          onPressed: () {
                            if (widget.serviceProvider.role == 1) {
                              Navigator.of(context).pushNamed('/appointment',
                                  arguments: appdetails);
                            } else {
                              Navigator.of(context).pushNamed(
                                  '/labAppointmentRequest',
                                  arguments: appdetails);
                            }
                          },
                          child: Text(
                            'Request Appointment',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1),
                          )),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Text((DateTime.now().isBefore(DateTime.parse(controller.appointments[index].date)) &&
// DateTime.now().add(Duration(days: 7)).isAfter(DateTime.parse(controller.appointments[index].date))
//                                   ) ? 
//                                     viewSlot(
//                                         controller.appointments[index].time,
//                                         controller.appointments[index].hour) 
//                                     :
//                                     ''
//                                     ,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                     ))