import 'package:aveksha/comp/conformer.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:aveksha/controllers/hrControl.dart';
import 'package:aveksha/controllers/reminderControl.dart';
import 'package:aveksha/controllers/userControl.dart';
import 'package:aveksha/patient/components/view_appointments.dart';
import 'package:aveksha/patient/components/hr_component.dart';
import 'package:aveksha/patient/components/prevAppointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import './components/tab_component.dart';
import 'components/reminder_component.dart';
import 'package:intl/intl.dart';

class PatientHome extends StatefulWidget {
  final Function logout;
  PatientHome({Key? key, required this.logout}) : super(key: key);

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final allMedicine = Get.put(AllReminders());
  final allHr = Get.put(AllHR());
  bool play = false;
  var _startDate = TextEditingController();
  var _endDate = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  setPlay(bool playValue) {
    setState(() {
      play = playValue;
    });
  }

  getPlay() {
    return play;
  }

  bool medActive = true;
  bool ehrActive = false;
  bool docActive = false;

  updateTab(index) {
    if (index == 0) {
      setState(() {
        medActive = true;
        ehrActive = false;
        docActive = false;
      });
    } else if (index == 1) {
      setState(() {
        ehrActive = true;
        medActive = false;
        docActive = false;
      });
    } else {
      setState(() {
        docActive = true;
        medActive = false;
        ehrActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isConfirmed = Get.find<UserInfo>().confirmed;
    TimeOfDay now = TimeOfDay.now();
    bool morning = now.hour > 4 && now.hour < 12;
    bool afternoon = now.hour >= 12 && now.hour < 18;
    bool evening = now.hour >= 18 && now.hour < 22;
    String gretting = morning
        ? "Morning"
        : afternoon
            ? "Afternoon"
            : evening
                ? "Evening"
                : "Night";
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

    searchHR() {
      if (_startDate.text.isNotEmpty && _endDate.text.isNotEmpty) {
        return ListView.builder(
            itemCount: allHr.allHr.length,
            itemBuilder: (context, index) {
              if (DateFormat.yMd()
                      .parse(allHr.allHr[index].date)
                      .isBefore(DateFormat.yMd().parse(_startDate.text)) ||
                  DateFormat.yMd()
                      .parse(allHr.allHr[index].date)
                      .isAfter(DateFormat.yMd().parse(_endDate.text))) {
                return Container();
              } else {
                return Column(
                  children: [
                    allHr.allHr[index],
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              }
            });
      } else {
        return Center(
          child: Text("Set dates and search to view HR"),
        );
      }
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Stack(
        children: [
          isConfirmed? Conformer(): Container(),
          Container(
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
                                "HELLO " + Get.find<UserInfo>().firstName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1
                                    ..color = Colors.black,
                                ),
                              ),
                              Text("GOOD $gretting!"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: TabComponent(
                        name: "MED",
                        isActive: medActive,
                        heightRatio: 0.06,
                        widthRatio: 0.25,
                      ),
                      onTap: () => updateTab(0),
                    ),
                    GestureDetector(
                      child: TabComponent(
                        name: "HR",
                        isActive: ehrActive,
                        heightRatio: 0.06,
                        widthRatio: 0.25,
                      ),
                      onTap: () => updateTab(1),
                    ),
                    GestureDetector(
                      child: TabComponent(
                        name: "DOC",
                        isActive: docActive,
                        heightRatio: 0.06,
                        widthRatio: 0.25,
                      ),
                      onTap: () => updateTab(2),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                if (medActive)
                  Expanded(
                    child: GetX<AllReminders>(builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.allMedicine.length,
                        itemBuilder: (context, index) {
                          return controller.allMedicine[index];
                        },
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      );
                    }),
                  ),
                if (docActive)
                  Column(
                    children: [
                      Text('Appointments'),
                      SizedBox(
                        height: 200,
                        child: GetX<ListofAppointments>(
                          builder: (controller) {
                            List<AppointMents> activeAndPendingFiltered =
                                controller
                                    .ownAppointments
                                    .where((p0) =>
                                        p0.status == 'Pending' ||
                                        p0.status == 'Active')
                                    .toList();

                            return ListView.builder(
                                itemCount: activeAndPendingFiltered.length,
                                itemBuilder: (context, index) {
                                  return DoctorAppointment(
                                      status: activeAndPendingFiltered[index]
                                          .status,
                                      doctorName:
                                          activeAndPendingFiltered[index]
                                              .doctor_Name,
                                      context: context,
                                      speciality:
                                          activeAndPendingFiltered[index]
                                              .speciality,
                                      appointmentDate: DateFormat.MMMd().format(
                                          DateTime.parse(
                                              activeAndPendingFiltered[index]
                                                  .date)),
                                      appointmentTime:
                                          activeAndPendingFiltered[index].time);
                                });
                          },
                        ),
                      ),
                      // ...appointments,
                      Divider(),
                      Text('Previous Interactions'),
                      SizedBox(
                        height:
                            150, // (250 - 50) where 50 units for other widgets
                        // child: ListView(
                        //     padding: EdgeInsets.symmetric(vertical: 2.0),
                        //     shrinkWrap: true,
                        //     children: prevAppointments),
                        child: GetX<ListofAppointments>(
                          builder: (controller) {
                            List<AppointMents> activeAndPendingFiltered =
                                controller
                                    .ownAppointments
                                    .where((p0) =>
                                        p0.status == 'Declined' ||
                                        p0.status == 'Inactive')
                                    .toList();
                            return ListView.builder(
                                itemCount: activeAndPendingFiltered.length,
                                itemBuilder: (context, index) {
                                  return PrevDoctorAppointment(
                                      appointment:
                                          activeAndPendingFiltered[index]);
                                });
                          },
                        ),
                      ),
                      // ...prevAppointments
                    ],
                  ),
                if (ehrActive)
                  Expanded(
                    child: Column(
                      children: [
                        searchHealthRecords(context, _startDate, _endDate),
                        Expanded(
                          child: searchHR(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!docActive)
            Positioned(
              top: height * 0.775,
              left: width * 0.85,
              child: FloatingActionButton(
                onPressed: () async {
                  if (medActive) {
                    await addReminder(context);
                  } else {
                    await addHealthRecords(context);
                  }
                },
                backgroundColor: Color(0xFF60BBFE).withOpacity(0.75),
                child: Icon(Icons.add, color: Colors.white, size: 32),
              ),
            )
        ],
      ),
      onTap: () {
        // setPlay(false);
        Get.find<AllReminders>().play = false;
      },
    );
  }
}
