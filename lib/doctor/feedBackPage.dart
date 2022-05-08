import 'package:aveksha/comp/feedBacks.dart';
import 'package:aveksha/controllers/feedbackControl.dart';
import 'package:aveksha/doctor/components/appointmentReq.dart';
import 'package:aveksha/doctor/components/scheduledAppointments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../patient/components/tab_component.dart';

class FeedBackPage extends StatefulWidget {
  final Function logout;
  FeedBackPage({Key? key, required this.logout}) : super(key: key);

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  getFeeds() async {
    var storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "accessToken");
    Get.find<ListOfFeedbacks>().getFeedbacks(accessToken: accessToken!);
  }

  @override
  void initState() {
    super.initState();
    getFeeds();
  }

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem> menuItems = [
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
    return Scaffold(
      backgroundColor: const Color(0xFFE1EBF1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE1EBF1),
        elevation: 0,
        title: Container(
            // child: Image.asset('image/aveksha_logo.png'),
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child:
                Image.asset('images/aveksha_logo.png', height: 100, width: 200),
            padding: EdgeInsets.all(5.0)),
      ),
      body: Container(
        height: height,
        color: const Color(0xFFE1EBF1),
        padding: EdgeInsets.symmetric(
            vertical: height * 0.05, horizontal: width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FEEDBACKS",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: GetX<ListOfFeedbacks>(builder: (controller) {
                return ListView.builder(
                    itemCount: controller.feedbacks.length,
                    itemBuilder: ((context, index) {
                      return FeedBackView(
                          feedback: controller.feedbacks[index].comment,
                          patientName: controller.feedbacks[index].firstName,
                          rating: controller.feedbacks[index].rating);
                    }));
              }),
            )
          ],
        ),
      ),
    );
  }
}
