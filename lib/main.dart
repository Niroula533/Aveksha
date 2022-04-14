// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/userControl.dart';
import 'routeGenerator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(UserInfo());
  final storage = FlutterSecureStorage();
  var role = await storage.read(key: 'role');
  var accessToken = await storage.read(key: 'accessToken');
  var roledUser;
  var initialRoute;
  if (role != null && accessToken != null) {
    var refreshToken = await storage.read(key: 'refreshToken');
    var response = await Dio().post(
      'http://10.0.2.2:3000/user',
      data: {'accessToken': accessToken, 'refreshToken': refreshToken},
      options: Options(validateStatus: ((status) {
        return status! < 500;
      })),
    );
    print(response.data);

    if (response.data['user'] != null) {
      var user = response.data['user']['user'];
      roledUser = response.data['user']['roledUser'];
      if (response.data['accessToken'] != null) {
        await storage.write(
            key: 'accessToken', value: response.data['accessToken']);
      }
      if (role == '0') {
        Get.find<UserInfo>().updateInfo(
            firstName: user['firstName'],
            lastName: user['lastName'],
            email: user['email'],
            phone: user['contact'],
            role: user['role'],
            address: user['address'],
            dob: roledUser['DOB'],
            gender: roledUser['gender']);
        initialRoute = '/patientMain';
      } else if (role == '1') {
        Get.find<UserInfo>().updateInfo(
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          phone: user['contact'],
          role: user['role'],
          address: user['address'],
          nmc: roledUser['nmc'],
        );
        // return '/doctorMain';
        initialRoute = '/patientMain';
      } else if (role == '2') {
        Get.find<UserInfo>().updateInfo(
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          phone: user['contact'],
          role: user['role'],
          address: user['address'],
        );
        // return '/labTechnicianMain';
        initialRoute = '/patientMain';
      }
    }
  } else {
    initialRoute = '/login';
    // initialRoute = '/patientMain';
  }

  runApp(MyApp(
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aveksha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:
          initialRoute, // NOTE TO WATCH: pass arguments to initial Route while logging in initially
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
