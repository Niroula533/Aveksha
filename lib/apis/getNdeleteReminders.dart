import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:dio/dio.dart';

Future<List> getReminder() async {
  final storage = FlutterSecureStorage();
  var accessToken = await storage.read(key: 'accessToken');
  var refreshToken = await storage.read(key: 'refreshToken');
  var response = await Dio().post('http://10.0.2.2:3000/user/getReminder',
      data: {'accessToken': accessToken, 'refreshToken': refreshToken});
  if (response.data != null) {
    return response.data;
  } else {
    return [];
  }
}

Future<String> deleteReminder(id) async {
  var response = await Dio()
      .post('http://10.0.2.2:3000/user/delReminder', data: {'reminderId': id});
  return response.data['msg'];
}
