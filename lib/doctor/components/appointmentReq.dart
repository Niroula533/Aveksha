import 'package:flutter/material.dart';

class AppointmentRequest extends StatelessWidget {
  final String patientName, dateTime;
  AppointmentRequest(
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
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 'Dr. $doctorName',
                            patientName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            dateTime,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check_outlined,
                          color: Colors.white,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )))),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
    ]);
  }
}
