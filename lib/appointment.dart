// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class AppointmentDetails {
  final String patientName;
  final String pproblem;
  final TimeOfDay ptime;
  var phours;
  final String pdate;
  AppointmentDetails(
      this.patientName, this.pdate, this.ptime, this.phours, this.pproblem);
}

class AppointmentRequest extends StatefulWidget {
  String patientName;
  AppointmentRequest({Key? key, required this.patientName}) : super(key: key);

  @override
  State<AppointmentRequest> createState() =>
      _AppointmentRequestState(this.patientName);
}

class _AppointmentRequestState extends State<AppointmentRequest> {
  // _patientName for name
  // _pickedDate for date picked in
  // _pickedTime for time picked in TimeOFDate. Example: 19:30, 7:30
  // _pickedHour for number of hours picked Example: 0.5,1,1.5,2
  // _problem for specifying problem faced
  String patientName;
  _AppointmentRequestState(this.patientName) {}
  final TextEditingController _pickedDate = TextEditingController();
  final TextEditingController _problem = TextEditingController();

  @override
  void dispose() {
    _problem.dispose();
    _pickedDate.dispose();
    super.dispose();
  }

  //Widget selectTime() {
  // return Column(
  //   children: [
  //     SizedBox(
  //       height: 100,
  //       child: CupertinoDatePicker(
  //           initialDateTime: _pickedTime
  //               .add(Duration(minutes: 30 - _pickedTime.minute % 30)),
  //           minuteInterval: 30,
  //           mode: CupertinoDatePickerMode.time,
  //           onDateTimeChanged: (dateTime) {
  //             setState(() {
  //               _pickedTime = dateTime;
  //             });
  //           }),
  //     ),
  //   ],
  // );
  //}
  DateTime _time = DateTime.now();
  TimeOfDay? _pickedTime;

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
                                _pickedTime = TimeOfDay.fromDateTime(
                                    DateTime.parse('$_time'));
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
        backgroundColor: Color.fromARGB(255, 17, 119, 121),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('Request Appointment'),
      ),
      backgroundColor: Color.fromARGB(255, 183, 222, 222),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'Patient Name:  $patientName',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Divider(
              thickness: 2,
            ),
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
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
                            // print(_pickedDate.text);
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
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
                                  'Time',
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                            //print(_pickedHours);
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
            Divider(
              thickness: 2,
            ),
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
                  onPressed: () {
                    Navigator.of(context).pushNamed('/doctorviewappointment',
                        arguments: AppointmentDetails(
                            patientName,
                            _pickedDate.text,
                            _pickedTime!,
                            _pickedHours,
                            _problem.text));
                  },
                  child: Text("Book")),
            ),
            // Column(
            //   children: [
            //     SizedBox(
            //       height: 100,
            //       child: CupertinoDatePicker(
            //           initialDateTime: _pickedTime
            //               .add(Duration(minutes: 30 - _pickedTime.minute % 30)),
            //           minuteInterval: 30,
            //           mode: CupertinoDatePickerMode.time,
            //           onDateTimeChanged: (dateTime) {
            //             setState(() {
            //               _pickedTime = dateTime;
            //             });
            //           }),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
