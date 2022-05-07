import 'package:aveksha/comp/navigation_bar.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../patient/components/tab_component.dart';

class PatientToDoctor extends StatefulWidget {
  final DocOrLab serviceProvider;
  PatientToDoctor({Key? key, required this.serviceProvider}) : super(key: key);

  @override
  State<PatientToDoctor> createState() => _PatientToDoctorState();
}

class _PatientToDoctorState extends State<PatientToDoctor> {
  bool feedbackActive = false;
  bool scheduleActive = true;

  updateTab(index) {
    if (index == 0) {
      setState(() {
        feedbackActive = false;
        scheduleActive = true;
      });
    } else {
      setState(() {
        scheduleActive = false;
        feedbackActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String docOrlabName = widget.serviceProvider.firstName;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: const Color(0xFFE1EBF1),
        padding: EdgeInsets.symmetric(
            vertical: height * 0.05, horizontal: width * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: height * 0.095,
                    width: height * 0.095,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.serviceProvider.role == 1
                            ? "Dr. $docOrlabName"
                            : docOrlabName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        widget.serviceProvider.speciality.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: TabComponent(
                    name: "SCHEDULES",
                    isActive: scheduleActive,
                    heightRatio: 0.07,
                    widthRatio: 0.375,
                  ),
                  onTap: () => updateTab(0),
                ),
                GestureDetector(
                  child: TabComponent(
                    name: "FEEDBACKS",
                    isActive: feedbackActive,
                    heightRatio: 0.07,
                    widthRatio: 0.35,
                  ),
                  onTap: () => updateTab(1),
                )
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            if (feedbackActive) Container(),
            if (scheduleActive)
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(2.5)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF60BBFE)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/appointment', arguments: widget.serviceProvider);
                      },
                      child: Text(
                        'Request Appointment',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1),
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// to send notification 
// IMP
