// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:aveksha/controllers/userControl.dart';

import '../../controllers/doctorControl.dart';

class ScheduleAppointmentLab extends StatefulWidget {
  const ScheduleAppointmentLab({Key? key}) : super(key: key);
  @override
  State<ScheduleAppointmentLab> createState() =>
      _ScheduleAppointmentLabState();
}

class _ScheduleAppointmentLabState extends State<ScheduleAppointmentLab> {

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
                        DateFormat('MMM dd')
                            .format(DateTime.now().add(Duration(days: 1))),
                    style: TextStyle(fontSize: 18))
              ],
            ),
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
                List<AppointMents> activeAppointments = controller.appointments
                    .where((p0) => p0.status == "Active").toList();
                return ListView.builder(
                  itemCount: activeAppointments.length,
                  itemBuilder: (context, index) {
                    if (DateTime.now().isBefore(DateTime.parse(
                            activeAppointments[index].date)) &&
                        DateTime.parse(activeAppointments[index].date)
                            .isBefore(DateTime.now().add(Duration(days: 7)))) {
                      if (DateFormat('EEEE').format(DateTime.parse(
                              activeAppointments[index].date)) ==
                          DateFormat('EEEE')
                              .format(DateTime.now().add(Duration(days: 1)))) {
                        return Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 156, 31, 22),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white)),
                                child: Text(                                  
                                        activeAppointments[index].time,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          height: 0,
                        );
                      }
                    } else {
                      return Container(
                        height: 0,
                      );
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }),
            ),
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
                        DateFormat('MMM dd')
                            .format(DateTime.now().add(Duration(days: 2))),
                    style: TextStyle(fontSize: 18))
              ],
            ),
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
                List<AppointMents> activeAppointments = controller.appointments
                    .where((p0) => p0.status == "Active").toList();
                return ListView.builder(
                  itemCount: activeAppointments.length,
                  itemBuilder: (context, index) {
                    if (DateTime.now().isBefore(DateTime.parse(
                            activeAppointments[index].date)) &&
                        DateTime.parse(activeAppointments[index].date)
                            .isBefore(DateTime.now().add(Duration(days: 7)))) {
                      if (DateFormat('EEEE').format(DateTime.parse(
                              activeAppointments[index].date)) ==
                          DateFormat('EEEE')
                              .format(DateTime.now().add(Duration(days: 2)))) {
                        return Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 156, 31, 22),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white)),
                                child: Text(                                  
                                        activeAppointments[index].time,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          height: 0,
                        );
                      }
                    } else {
                      return Container(
                        height: 0,
                      );
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }),
            ),
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
                        DateFormat('MMM dd')
                            .format(DateTime.now().add(Duration(days: 3))),
                    style: TextStyle(fontSize: 18))
              ],
            ),
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
                List<AppointMents> activeAppointments = controller.appointments
                    .where((p0) => p0.status == "Active").toList();
                return ListView.builder(
                  itemCount: activeAppointments.length,
                  itemBuilder: (context, index) {
                    if (DateTime.now().isBefore(DateTime.parse(
                            activeAppointments[index].date)) &&
                        DateTime.parse(activeAppointments[index].date)
                            .isBefore(DateTime.now().add(Duration(days: 7)))) {
                      if (DateFormat('EEEE').format(DateTime.parse(
                              activeAppointments[index].date)) ==
                          DateFormat('EEEE')
                              .format(DateTime.now().add(Duration(days: 3)))) {
                        return Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 156, 31, 22),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white)),
                                child: Text(                                  
                                        activeAppointments[index].time,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          height: 0,
                        );
                      }
                    } else {
                      return Container(
                        height: 0,
                      );
                    }
                  },
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                );
              }),
            ),
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
                        DateFormat('MMM dd')
                            .format(DateTime.now().add(Duration(days: 4))),
                    style: TextStyle(fontSize: 18))
              ],
            ),
            Container(
              height: 40,
              child: GetX<ListofAppointments>(builder: (controller) {
                List<AppointMents> activeAppointments = controller.appointments
                    .where((p0) => p0.status == "Active").toList();
                return ListView.builder(
                  itemCount: activeAppointments.length,
                  itemBuilder: (context, index) {
                    if (DateTime.now().isBefore(DateTime.parse(
                            activeAppointments[index].date)) &&
                        DateTime.parse(controller.appointments[index].date)
                            .isBefore(DateTime.now().add(Duration(days: 7)))) {
                      if (DateFormat('EEEE').format(DateTime.parse(
                              activeAppointments[index].date)) ==
                          DateFormat('EEEE')
                              .format(DateTime.now().add(Duration(days: 4)))) {
                        return Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 156, 31, 22),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white)),
                                child: Text(                                  
                                        activeAppointments[index].time,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          height: 0,
                        );
                      }
                    } else {
                      return Container(
                        height: 0,
                      );
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
