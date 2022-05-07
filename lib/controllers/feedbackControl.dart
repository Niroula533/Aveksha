import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class Feedback {
  final String firstName, comment;
  final rating, id;

  Feedback(
      {required this.comment,
      required this.firstName,
      required this.rating,
      required this.id});
}

class ListOfFeedbacks extends GetxController {
  var feedbacks = <Feedback>[].obs;

  @override
  void onInit() {
    super.onInit();
    getFeedbacks();
  }

  Future getFeedbacks({String? accessToken, String? doctor_user_id}) async {
    var response;
    if (accessToken != null) {
      response = await Dio().post('http://localhost:3000/user/getFeedback',
          data: {"accessToken": accessToken});
    } else {
      response = await Dio().post('http://localhost:3000/user/getFeedback',
          data: {"doctor_user_id": doctor_user_id});
    }
    feedbacks.value = response.data['feedbacks']
        .map<Feedback>((value) => Feedback(
            comment: value['comment'],
            firstName: value['firstName'],
            rating: value['rating'],
            id: value['_id']))
        .toList();
  }
//   Future addFeedbacks({})
}
