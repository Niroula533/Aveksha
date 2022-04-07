// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:aveksha/patientRegistrationPage.dart';
import 'package:aveksha/doctorRegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:aveksha/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  bool _viewpw = true;

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
                      margin: EdgeInsets.all(15),
                      child: Center(
                          child: Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ))),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Email',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is Empty';
                              }
                              return null;
                            },
                            obscureText: _viewpw,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(_viewpw
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _viewpw = !_viewpw;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Password',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            // after login route here
                            if (_formkey.currentState!.validate())
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
                                child: Text('Login'),
                              )),
                        ),
                        Center(
                            child: Text(
                          'Dont have an account? Sign up with us',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).pushNamed('/registration')
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 6, 173, 159),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text('Sign Up'),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
