import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aveksha/controllers/userControl.dart';

Future<dynamic> handleLogin(
    {required BuildContext context, required email, required password}) async {
  try {
    final storage = FlutterSecureStorage();
    var response = await Dio().post(
      'http://10.0.2.2:3000/user/login',
      data: {'email': email, 'password': password},
      options: Options(validateStatus: ((status) {
        return status! < 500;
      })),
    );
    if (response.data['user'] == null) {
      var h = response.data["msg"];
      final snack = SnackBar(
        content: Text(h),
      );
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    var user = response.data['user']['user'];
    var roledUser = response.data['user']['roledUser'];
    print(user);
    await FirebaseMessaging.instance.subscribeToTopic(user['phone'].toString());

    if (user['role'] == 0) {
      Get.find<UserInfo>().updateInfo(
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          phone: user['phone'],
          role: user['role'],
          address: user['address'],
          dob: roledUser['pickedDate'],
          gender: roledUser['gender'],
          confirmed: user["confirmed"]);
    } else if (user['role'] == 1) {
      Get.find<UserInfo>().updateInfo(
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          phone: user['phone'],
          role: user['role'],
          address: user['address'],
          nmc: roledUser['nmc'],
          speciality: roledUser['speciality'],
          confirmed: user["confirmed"]);
    } else {
      Get.find<UserInfo>().updateInfo(
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          phone: user['phone'],
          role: user['role'],
          address: user['address'],
          speciality: roledUser['speciality'],
          confirmed: user["confirmed"]);
    }
    await storage.write(key: 'role', value: user['role'].toString());
    await storage.write(
        key: 'accessToken', value: response.data['accessToken']);
    await storage.write(
        key: 'refreshToken', value: response.data['refreshToken']);
    if (user['role'] == 0) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/patientMain', (Route<dynamic> route) => false);
    } else if (user['role'] == 1) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/doctorMain', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/doctorMain',
          (Route<dynamic> route) => false); // NOTE: should be /labtechMain
    }
    return '';
  } catch (e) {
    print(e);
    return e.toString();
  }
}
