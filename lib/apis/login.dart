import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
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
    if (user['role'] == 0) {
      Get.find<UserInfo>().updateInfo(
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          phone: user['contact'],
          role: user['role'],
          address: user['address'],
          dob: roledUser['pickedDate'],
          gender: roledUser['gender']);
    } else if (user['role'] == 1) {
      Get.find<UserInfo>().updateInfo(
        firstName: user['firstName'],
        lastName: user['lastName'],
        email: user['email'],
        phone: user['contact'],
        role: user['role'],
        address: user['address'],
        nmc: roledUser['nmc'],
      );
    } else {
      Get.find<UserInfo>().updateInfo(
        firstName: user['firstName'],
        lastName: user['lastName'],
        email: user['email'],
        phone: user['contact'],
        role: user['role'],
        address: user['address'],
      );
    }
    await storage.write(key: 'role', value: user['role'].toString());
    await storage.write(
        key: 'accessToken', value: response.data['accessToken']);
    await storage.write(
        key: 'refreshToken', value: response.data['refreshToken']);
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/patientMain', (Route<dynamic> route) => false);
    // Navigator.of(context).popAndPushNamed('/patientMain');
    return '';

    // return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text("Login unsuccessfull!"),
    //         content: Text(h),
    //         actions: <Widget>[
    //           TextButton(
    //               onPressed: () => Navigator.of(context).pop(),
    //               child: Text("Retry")),
    //           TextButton(
    //               onPressed: () => Navigator.of(context).pushNamed('/login'),
    //               child: Text("LogIn"))
    //         ],
    //       );
    //     });
  } catch (e) {
    print(e);
    return e.toString();
  }
}
