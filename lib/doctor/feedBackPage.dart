import 'package:aveksha/comp/feedBacks.dart';
import 'package:aveksha/doctor/components/appointmentReq.dart';
import 'package:aveksha/doctor/components/scheduledAppointments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../patient/components/tab_component.dart';

class FeedBackPage extends StatefulWidget {
  final Function logout;
  FeedBackPage({Key? key, required this.logout}) : super(key: key);

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
 
  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem> menuItems = [
      PopupMenuItem(child: Text("Edit Profile")),
      PopupMenuItem(
          child: TextButton(
        child: Text("Sign Out"),
        onPressed: () async {
          final storage = FlutterSecureStorage();
          await storage.deleteAll();
          // Navigator.of(context).pushReplacementNamed('/login');
          await widget.logout();
        },
      ))
    ];
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: const Color(0xFFE1EBF1),
      padding: EdgeInsets.symmetric(
          vertical: height * 0.05, horizontal: width * 0.04),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      children: [
                        Text(
                          "HELLO END",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = Colors.black,
                          ),
                        ),
                        Text("GOOD MORNING!"),
                      ],
                    ),
                  )
                ],
              ),
              PopupMenuButton(itemBuilder: (context) => [...menuItems])
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Text("FEEDBACKS"),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          FeedBack(patientName: "Mr. Ankush", feedback: "Throughly helped me with my problem and gave proper advise.", rating: 4),
          FeedBack(patientName: "Mr. Ankush", feedback: "Throughly helped me with my problem and gave proper advise.", rating: 4),
          FeedBack(patientName: "Mr. Ankush", feedback: "Throughly helped me with my problem and gave proper advise.", rating: 4),
          FeedBack(patientName: "Mr. Ankush", feedback: "Throughly helped me with my problem and gave proper advise.", rating: 4),
        ],
      ),
    );
  }
}
