// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks, prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:aveksha/apis/flutter_notifications.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:aveksha/controllers/userControl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class AppointmentDetails {
  final String pname;
  final String pproblem;
  final TimeOfDay ptime;
  var phours;
  final String pdate;
  AppointmentDetails(
      this.pname, this.pdate, this.ptime, this.phours, this.pproblem);
}

class AppointmentRequest extends StatefulWidget {
  final DocOrLab serviceProvider;
  const AppointmentRequest({Key? key, required this.serviceProvider})
      : super(key: key);

  @override
  State<AppointmentRequest> createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> {
  // _patientName for name
  // _pickedDate for date picked in
  // _pickedTime for time picked in TimeOFDate. Example: 19:30, 7:30
  // _pickedHour for number of hours picked Example: 0.5,1,1.5,2
  // _problem for specifying problem faced

  final TextEditingController _patientName = TextEditingController();
  final TextEditingController _pickedDate = TextEditingController();
  final TextEditingController _problem = TextEditingController();

  @override
  void dispose() {
    _problem.dispose();
    _pickedDate.dispose();
    _patientName.dispose();
    super.dispose();
  }

  DateTime _time = DateTime.now();
  String? _pickedTime;

  Future<void> viewTime(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: AlertDialog(
                  scrollable: true,
                  title: Text('Add time'),
                  content: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: CupertinoDatePicker(
                            initialDateTime: _time
                                .add(Duration(minutes: 30 - _time.minute % 30)),
                            minuteInterval: 30,
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (DateTime dateTime) {
                              setState(() {
                                _time = dateTime;
                                _pickedTime = DateFormat.Hm().format(_time);
                              });
                            }),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok'))
                    ],
                  )));
        });
  }

  var _pickedHours;
  String? validate(String value) {
    if (value.isEmpty) {
      return 'Field cant be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF60BBFE),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.backspace)),
        title: Text('Request Appointment'),
      ),
      backgroundColor: Color(0xFFE1EBF1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'Whom do you want to book appointment for?',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                  controller: _patientName,
                  decoration: InputDecoration(
                    errorText: validate(_patientName.toString()),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Enter Name Here',
                  )),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Specify Date and Time',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.85,
                      child: TextFormField(
                        controller: _pickedDate,
                        inputFormatters: [DateInputFormatter()],
                        keyboardType: TextInputType.number,
                        validator: (_dateTime) {
                          if (_dateTime == null || _dateTime.isEmpty) {
                            return 'Field is Empty';
                          }
                          return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'Date',
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          DateTime? _dateTime = null;
                          _dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 7)))
                              .then((date) {
                            setState(() {
                              _dateTime = date;
                            });
                            if (_dateTime != null &&
                                _dateTime != DateTime.now) {
                              String stringDate =
                                  DateFormat('yyyy-MM-dd').format(date!);
                              _pickedDate.text = stringDate;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.85,
                      child: GestureDetector(
                        onTap: () async {
                          await viewTime(context);
                        },
                        child: Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _pickedTime != null?_pickedTime!:'Time',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.60),
                                      fontSize: 16),
                                ))),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: DropdownButton(
                          hint: Text('Hours'),
                          value: _pickedHours,
                          onChanged: (value) {
                            setState(() {
                              _pickedHours = value;
                            });
                          },
                          items: <double>[0.5, 1, 1.5, 2]
                              .map<DropdownMenuItem<double>>((var value) {
                            return DropdownMenuItem<double>(
                                value: value, child: Text('$value'));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Specify Problem',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                  minLines: 5,
                  maxLines: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is empty';
                    }
                    return null;
                  },
                  controller: _problem,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Enter Details Here',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: ElevatedButton(
                  onPressed: () async {
                    var storage = FlutterSecureStorage();
                    final accessToken = await storage.read(key: 'accessToken');
                    var requestAppointment = {
                      "status": "Pending",
                      "date": _pickedDate.text,
                      "time": _pickedTime,
                      "problem": _problem.text,
                      "patient_Name": Get.find<UserInfo>().firstName,
                    };
                    var response = await Dio().post(
                        'http://10.0.2.2:3000/doctor/addAppointment',
                        data: {
                          "accessToken": accessToken,
                          "doctorId": widget.serviceProvider.id,
                          "requestAppointment": requestAppointment
                        });
                    await NotificationApi().sendRemote(
                        title: "Appointment Request",
                        body: "You have new appointment request",
                        topic: widget.serviceProvider.phone.toString());
                  },
                  child: Text("Book")),
            ),
          ],
        ),
      ),
    );
  }
}
