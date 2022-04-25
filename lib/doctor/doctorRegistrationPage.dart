// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../apis/register.dart';

class DoctorRegistrationPage extends StatefulWidget {
  const DoctorRegistrationPage({Key? key}) : super(key: key);

  @override
  State<DoctorRegistrationPage> createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _nmc = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _contact = TextEditingController();

  @override
  void dispose() {
    _pass.dispose();
    _confirmPass.dispose();
    _nmc.dispose();
    _fullName.dispose();
    _email.dispose();
    _address.dispose();
    _contact.dispose();
    super.dispose();
  }

  final storage = FlutterSecureStorage();
  Widget InputBox(text, textController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: textController,
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
                Navigator.of(context).pushNamed('/login');
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
                          InputBox('Full Name', _fullName),
                          InputBox('Email', _email),
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
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _nmc,
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
                                labelText: 'NMC Number',
                              ),
                            ),
                          ),
                          InputBox('Address', _address),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _contact,
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
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await handleRegister(
                                    fullName: _fullName.text,
                                    context: context,
                                    email: _email.text,
                                    contact: _contact.text,
                                    pass: _pass.text,
                                    address: _address.text,
                                    nmc: num.parse(_nmc.text),
                                    role: 1);
                              }
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
