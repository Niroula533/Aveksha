import 'package:aveksha/controllers/doctorControl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../controllers/userControl.dart';

class FeedBackView extends StatelessWidget {
  final String patientName, feedback;
  final int rating;
  const FeedBackView(
      {Key? key,
      required this.patientName,
      required this.feedback,
      required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(patientName);
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

void showRatingAppDialog(
    {required String doctor_id,
    required context,
    required String appointmentId}) {
  final ratingDialog = RatingDialog(
    // ratingColor: Colors.amber,
    title: Text('Please rate your experience',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold)),
    message: const Text(
        'your feed back will be displayed in the profile of Doctor',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15)),
    image: Image.asset(
      "images/IconOnly.png",
      height: 100,
    ),
    submitButtonText: 'Submit',
    commentHint: 'Leave a review ',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) async {
      print('rating: ${response.rating}, '
          'comment: ${response.comment}'
          'doctor_id:$doctor_id');

      final storage = FlutterSecureStorage();
      String patientName = Get.find<UserInfo>().firstName;
      var accessToken = await storage.read(key: 'accessToken');
      await Dio().post('http://10.0.2.2:3000/user/rating', data: {
        'accessToken': accessToken,
        'doctor_id': doctor_id,
        'rating': response.rating,
        'comment': response.comment,
        'patientName': patientName
      });
      Get.find<ListofAppointments>()
          .updateAppointments(status: "Reviewed", id: appointmentId);
      Get.find<ListofAppointments>().update();
    },
  );
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => ratingDialog,
  );
}
