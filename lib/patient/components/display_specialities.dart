import 'dart:convert';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'display_listOfDoctor.dart';

class Specialities extends StatefulWidget {
  final updateIndex;
  Specialities({Key? key, required this.updateIndex}) : super(key: key);
  @override
  State<Specialities> createState() => _SpecialitiesState();
}

class _SpecialitiesState extends State<Specialities> {
  final listDoctors = Get.find<ListOfDoctorsAndLabtech>().doctors;
  final listLabTechs = Get.find<ListOfDoctorsAndLabtech>().labTechs;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        // Listing for Top Specialities
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Top Specialities',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        GetX<ListOfDoctorsAndLabtech>(builder: (controller) {
          return ListView.builder(
            itemCount: controller.doctors.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  widget.updateIndex(
                    isDoctor: true,
                      index: 3,
                      specialization: controller.doctors[index].speciality);
                },
                child: Card(
                  color: Color.fromARGB(255, 228, 234, 235),
                  elevation: 0,
                  shadowColor: Colors.red.withOpacity(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: null,
                        child: Text(controller.doctors[index].speciality,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                      ),
                      Text(controller.doctors[index].speciality,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                    ],
                  ),
                ),
              );
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          );
        }),
        // Listing for Common Health Issue

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Lab Reports',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        GetX<ListOfDoctorsAndLabtech>(builder: (controller) {
          return ListView.builder(
            itemCount: controller.labTechs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  widget.updateIndex(
                    isDoctor: false,
                      index: 3,
                      specialization: controller.labTechs[index].speciality);
                },
                child: Card(
                  color: Color.fromARGB(255, 228, 234, 235),
                  elevation: 0,
                  shadowColor: Colors.red.withOpacity(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: null,
                        child: Text(controller.labTechs[index].speciality,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                      ),
                      Text(controller.labTechs[index].speciality,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          )),
                    ],
                  ),
                ),
              );
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          );
        }),
      ],
    );
  }
}

class Display extends StatelessWidget {
  final String text;

  const Display({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
