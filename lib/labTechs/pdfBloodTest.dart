// ignore_for_file: file_names, prefer_const_constructors, no_logic_in_create_state, prefer_const_literals_to_create_immutables

import 'package:aveksha/labTechs/bloodTest.dart';
import 'package:screenshot/screenshot.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart ' as pw;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../controllers/userControl.dart';

class PdfBloodTest extends StatefulWidget {
  BloodTestData btdata;
  PdfBloodTest({Key? key, required this.btdata}) : super(key: key);

  @override
  State<PdfBloodTest> createState() => _PdfBloodTestState(btdata: btdata);
}

class _PdfBloodTestState extends State<PdfBloodTest> {
  String stringDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  BloodTestData btdata;
  _PdfBloodTestState({required this.btdata});

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    Get.put(UserInfo());
    super.initState();
  }

  final String _doctorName =
      Get.find<UserInfo>().firstName + ' ' + Get.find<UserInfo>().lastName;
  final int nmc = Get.find<UserInfo>().nmc;

  static GlobalKey previewContainer = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    var _image;

    takeScreenShot() async {
      RenderRepaintBoundary boundary = previewContainer.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      _image = MemoryImage(pngBytes);
      print(_image);
    }

    return RepaintBoundary(
      key: previewContainer,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              elevation: 0,
              title: Container(
                  // child: Image.asset('image/aveksha_logo.png'),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Image.asset('images/aveksha_logo.png',
                      height: 100, width: 200),
                  padding: EdgeInsets.all(5.0))),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 10, 0),
                  child: Text(
                    'Name of patient: ${btdata.pname}',
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
                Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                  child: Center(
                      child: Text('Blood Test Report',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 18))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Test Name',
                            style: TextStyle(fontSize: 16),
                          )),
                          Expanded(
                              child: Text('Results',
                                  style: TextStyle(fontSize: 16))),
                          Expanded(
                              child: Text('Normal Range',
                                  style: TextStyle(fontSize: 16)))
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('Haemoglobin')),
                          Expanded(child: Text('${btdata.haemoglobin}')),
                          Expanded(child: Text('11 - 16'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('RBC')),
                          Expanded(child: Text('${btdata.rbc}')),
                          Expanded(child: Text('3.5 - 5.5'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('HCT')),
                          Expanded(child: Text('${btdata.hct}')),
                          Expanded(child: Text('37.0 - 50.0'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('MCV')),
                          Expanded(child: Text('${btdata.mcv}')),
                          Expanded(child: Text('82 - 95'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('MCH')),
                          Expanded(child: Text('${btdata.mch}')),
                          Expanded(child: Text('27 - 31'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('MCHC')),
                          Expanded(child: Text('${btdata.mchc}')),
                          Expanded(child: Text('32 - 36'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('RDW-CV')),
                          Expanded(child: Text('${btdata.rdwcv}')),
                          Expanded(child: Text('11.5 - 13.5'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('RDW-CV')),
                          Expanded(child: Text('${btdata.rdwsd}')),
                          Expanded(child: Text('35 - 56'))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('WBC')),
                          Expanded(child: Text('${btdata.wbc}')),
                          Expanded(child: Text('4.5 - 11'))
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text('Verified By: Dr. $_doctorName',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                          child: Text('Take SS'),
                          onPressed: () {
                            takeScreenShot();
                          }),
                    
                      // Container(
                      //   decoration: BoxDecoration(
                      //     image: new DecorationImage(
                      //     fit: BoxFit.cover, image: _image),
                      //   ),
                    //  )
                    ]
                    ,
                  ),
                )
              ]))),
    );
  }
}
