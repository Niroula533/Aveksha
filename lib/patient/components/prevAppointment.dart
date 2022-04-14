import 'package:flutter/material.dart';

class PrevDoctorAppointment extends StatelessWidget {
  final doctorName, speciality;
  const PrevDoctorAppointment({
    Key? key,
    required this.doctorName,
    required this.speciality,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100, minHeight: 60),
              child: Expanded(
                child: Container(
                    color: Colors.white.withOpacity(0.75),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. $doctorName',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              speciality,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(2.5)),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Color(0xFF60BBFE)),
                              ),
                              onPressed: null,
                              child: Text(
                                'GIVE FEEDBACK',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.1),
                              )),
                        )
                      ],
                    )),
              ))),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
    ]);
  }
}
