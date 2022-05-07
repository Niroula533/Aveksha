// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:aveksha/appointment.dart';
import 'package:flutter/material.dart';

class DoctorViewAppointment extends StatefulWidget {
  AppointmentDetails appointmentInfo;
  DoctorViewAppointment({Key? key, required this.appointmentInfo})
      : super(key: key);
  @override
  State<DoctorViewAppointment> createState() => _DoctorViewAppointmentState(
      appointmentInfo.pname,
      appointmentInfo.pdate,
      appointmentInfo.ptime,
      appointmentInfo.phours,
      appointmentInfo.pproblem);
}

class _DoctorViewAppointmentState extends State<DoctorViewAppointment> {
  String pname;
  String pproblem;
  var phours;
  TimeOfDay ptime;
  String pdate;
  _DoctorViewAppointmentState(
      this.pname, this.pdate, this.ptime, this.phours, this.pproblem) {}

  Future<void> viewDetails(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: AlertDialog(
                  scrollable: true,
                  title: Text('Appointment Details'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                'Patient Name',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.teal),
                              ),
                              Text(pname),
                              Text('Date and Time'),
                              Row(
                                children: [
                                  Text(pdate),
                                  Text(ptime.format(context))
                                ],
                              ),
                              Text('Problem'),
                              Text(pproblem)
                            ],
                          ),
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                textStyle: TextStyle(fontSize: 20)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Ok'))
                      ],
                    ),
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        viewDetails(context);
      },
    );
  }
}
