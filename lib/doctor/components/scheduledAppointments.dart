import 'package:flutter/material.dart';

class ScheduledAppoinements extends StatelessWidget {
  final String patientName, dateTime;
  ScheduledAppoinements(
      {Key? key, required this.patientName, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 80, minHeight: 60),
              child: Container(
                  color: Colors.white.withOpacity(0.75),
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // 'Dr. $doctorName',
                                  patientName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  dateTime,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ])))),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
    ]);
  }
}
