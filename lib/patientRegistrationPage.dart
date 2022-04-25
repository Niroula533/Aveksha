// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:intl/intl.dart';

class PatientRegistrationPage extends StatefulWidget {
  const PatientRegistrationPage({Key? key}) : super(key: key);

  @override
  State<PatientRegistrationPage> createState() =>
      _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _pickedDate = TextEditingController();

  @override
  void dispose() {
    _pass.dispose();
    _confirmPass.dispose();
    _pickedDate.dispose();
    super.dispose();
  }

  // Widget PickDate() {
  //   return ElevatedButton(
  //       child: Icon(Icons.calendar_today),
  //       onPressed: () {
  //         showDatePicker(
  //                 context: context,
  //                 initialDate: DateTime.now(),
  //                 firstDate: DateTime(2001),
  //                 lastDate: DateTime(2024))
  //             .then((date) {
  //           setState(() {
  //             _dateTime = date;
  //           });
  //         });
  //       });
  // }

  Widget InputBox(text) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field is Empty';
          }
          return null;
        },
        obscureText: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: '$text',
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
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
                color: Color.fromARGB(255, 228, 234, 235),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ),
                  Center(
                      child: Text('Your information is safe with us',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18))),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputBox('Full Name'),
                          InputBox('Email'),
                          // for checking password
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _pass,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field is Empty';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _confirmPass,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field is Empty';
                                }
                                if (value != _pass.text) {
                                  return 'Password doesn\'t match';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelText: 'Confirm Password',
                              ),
                            ),
                          ),

                          InputBox('Address'),
                          //DOB
                          Padding(
                            padding: const EdgeInsets.all(20),
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
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelText: 'Date Of Birth',
                              ),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                DateTime? _dateTime = null;
                                _dateTime = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2001),
                                        lastDate: DateTime(2024))
                                    .then((date) {
                                  setState(() {
                                    _dateTime = date;
                                  });
                                  String stringDate =
                                      DateFormat('yyyy-MM-dd').format(date!);
                                  _pickedDate.text = stringDate;
                                });
                              },
                            ),
                          ),

                          InputBox('Gender'),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field is Empty';
                                }
                                return null;
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelText: 'Contact',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              //funtion to go to login here
                              if (_formKey.currentState!.validate())
                                {Navigator.of(context).pushNamed('/login')}
                            },
                            child: Container(
                                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 6, 173, 159),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text('Register'),
                                )),
                          )
                        ],
                      )),
                ],
              ),
            )));
  }
}
