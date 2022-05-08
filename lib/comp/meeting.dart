import 'package:aveksha/controllers/doctorControl.dart';
import 'package:aveksha/controllers/userControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:intl/intl.dart';

class Meeting extends StatefulWidget {
  Meeting({Key? key}) : super(key: key);

  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  @override
  void initState() {
    super.initState();
    // Get.put(ListofAppointments());
    Get.find<ListofAppointments>().getOwnAppointments();

    // listenNotification();
  }

  @override
  Widget build(BuildContext context) {
    int role = Get.find<UserInfo>().role;
    return Scaffold(
        backgroundColor: const Color(0xFFE1EBF1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFE1EBF1),
          elevation: 0,
          title: Container(
              // child: Image.asset('image/aveksha_logo.png'),
              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Image.asset('images/aveksha_logo.png',
                  height: 100, width: 200),
              padding: EdgeInsets.all(5.0)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              "Scheduled Meetings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: GetX<ListofAppointments>(
                builder: (controller) {
                  List<AppointMents> activeAppointments = controller
                      .ownAppointments
                      .where((p0) => p0.status == "Active")
                      .toList();
                  return ListView.builder(
                      itemCount: activeAppointments.length,
                      itemBuilder: (context, index) {
                        DateTime p = DateFormat.Hm()
                            .parse(activeAppointments[index].time);
                        bool a = DateTime.now().isBefore(p);
                        print(a);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                color: Colors.white70,
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          role == 0
                                              ? activeAppointments[index]
                                                  .doctor_Name
                                              : activeAppointments[index]
                                                  .patient_Name,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (role == 0)
                                          Text(
                                            activeAppointments[index]
                                                .speciality,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic),
                                          )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat.MMMd().format(
                                              DateTime.parse(controller
                                                  .ownAppointments[index].date
                                                  .toString())),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(activeAppointments[index].time)
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          JitsiMeetMethods().createNewMeeting(
                                              activeAppointments[index]
                                                  .patient_phone
                                                  .toString(),
                                              activeAppointments[index]);
                                        },
                                        icon: Icon(Icons.videocam))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      });
                },
              ),
            ),
          ],
        ));
  }
}

class JitsiMeetMethods {
  void createNewMeeting(String room, AppointMents a) async {
    try {
      UserInfo user = Get.find<UserInfo>();
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
        FeatureFlagEnum.INVITE_ENABLED: false,
      };

      var options = JitsiMeetingOptions(room: "room")
        ..featureFlags.addAll(featureFlags)
        ..userDisplayName = user.firstName
        ..userEmail = user.email
        ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
        ..audioMuted = true
        ..videoMuted = true;

      await JitsiMeet.joinMeeting(options, listener: JitsiMeetingListener(
        onConferenceTerminated: (message) {
          Get.find<ListofAppointments>()
              .updateAppointments(status: "Inactive", id: a.id);
          Get.find<ListofAppointments>().update();
        },
      ));
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}
