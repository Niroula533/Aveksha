// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BloodTestLab extends StatefulWidget {
  String pname;
  BloodTestLab({Key? key, required this.pname}) : super(key: key);

  @override
  State<BloodTestLab> createState() => _BloodTestLabState(pname);
}

class _BloodTestLabState extends State<BloodTestLab> {
  String pname;
  final _formkey = GlobalKey<FormState>();
  _BloodTestLabState(this.pname) {}

  final TextEditingController _haemoglobin = TextEditingController();
  final TextEditingController _rbc = TextEditingController();
  final TextEditingController _wbc = TextEditingController();
//  final TextEditingController _problem = TextEditingController();

  String stringDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void dispose() {
    //  _problem.dispose();
    _haemoglobin.dispose();
    _rbc.dispose();
    _wbc.dispose();
    super.dispose();
  }

  String _doctorName = 'Sushant Adhikari';

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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 10, 0),
                child: Text(
                  'Name of patient: $pname',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 10, 0),
                child: Text(
                  'Date: $stringDate',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 2),
              Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _haemoglobin,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'null';
                            }
                            return null;
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: 'Haemoglobin Level',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _rbc,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'null';
                            }
                            return null;
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: 'RBC count',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _wbc,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'null';
                            }
                            return null;
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: 'WBC count',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Text('Verified By: $_doctorName',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: () => {
                          //funtion to go to login here
                          if (_formkey.currentState!.validate())
                            {Navigator.of(context).pushNamed('/pdfBloodTest')}
                        },
                        child: Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 6, 173, 159),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text('Submit'),
                            )),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
