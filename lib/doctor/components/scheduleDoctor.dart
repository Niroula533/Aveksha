// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:aveksha/controllers/userControl.dart';

import '../../controllers/doctorControl.dart';

class ScheduleAppointmentDoctor extends StatefulWidget {
  const ScheduleAppointmentDoctor({Key? key}) : super(key: key);
  @override
  State<ScheduleAppointmentDoctor> createState() =>
      _ScheduleAppointmentDoctorState();
}

class _ScheduleAppointmentDoctorState extends State<ScheduleAppointmentDoctor> {
   
  // void getAppointment() async {
  //   var storage = FlutterSecureStorage();
  //   var accessToken = await storage.read(key: "accessToken");
  //   await Get.find<ListofAppointments>().getAppointments(
  //       accessToken: accessToken, role: Get.find<UserInfo>().role);
  // }

  // @override
  // void initState() {
  //   getAppointment();
  //   super.initState();
  // }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
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
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
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
                        return Expanded(
                          child: Row(
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
                          ),
                        );
                      } else {
                        return Container(height: 0,);
                      }
                    } else {
                      return Container(height: 0,);
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }),
            ),
            Divider(thickness: 3,),

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
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
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
                        return Expanded(
                          child: Row(
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
                          ),
                        );
                      } else {
                        return Container(height: 0,);
                      }
                    } else {
                      return Container(height: 0,);
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }),
            ),
            Divider(thickness: 3,),

            
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
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
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
                        return Expanded(
                          child: Row(
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
                          ),
                        );
                      } else {
                        return Container(height: 0,);
                      }
                    } else {
                      return Container(height: 0,);
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }),
            ),
            Divider(thickness: 3,),

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
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
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
                        return Expanded(
                          child: Row(
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
                          ),
                        );
                      } else {
                        return Container(height: 0,);
                      }
                    } else {
                      return Container(height: 0,);
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }),
            ),
            Divider(
              thickness: 7,
            ),
            
          ],
        ),
      ),
    );
  }
}
