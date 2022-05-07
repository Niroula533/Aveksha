import 'package:aveksha/controllers/userControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class Meeting extends StatefulWidget {
  Meeting({Key? key}) : super(key: key);

  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ClipRRect(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: JitsiMeetMethods().createNewMeeting,
                    icon: Icon(Icons.videocam))
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class JitsiMeetMethods {
  void createNewMeeting() async {
    try {
      UserInfo user = Get.find<UserInfo>();
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution
          .MD_RESOLUTION; // Limit video resolution to 360p

      print(user.phone);
      var options = JitsiMeetingOptions(room: user.phone.toString())
        ..userDisplayName = user.firstName
        ..userEmail = user.email
        ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
        ..audioMuted = true
        ..videoMuted = true;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}
