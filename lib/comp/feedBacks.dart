import 'package:flutter/material.dart';

class FeedBack extends StatelessWidget {
  final String patientName, feedback;
  final int rating;
  const FeedBack(
      {Key? key,
      required this.patientName,
      required this.feedback,
      required this.rating})
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
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                            'Rating: $rating',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      Text(feedback)
                    ],
                  )))),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
    ]);
  }
}
