// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apis/flutter_notifications.dart';
import 'controllers/userControl.dart';
import 'routeGenerator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:dio/dio.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print(message.notification!.body);
    // NotificationApi().showNotification(
    //     title: message.notification!.title, body: message.notification!.body);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  Get.put(UserInfo());
  final storage = FlutterSecureStorage();
  var role = await storage.read(key: 'role');
  var accessToken = await storage.read(key: 'accessToken');
  var roledUser;
  var initialRoute = '/login';
  if (role != null && accessToken != null) {
    var refreshToken = await storage.read(key: 'refreshToken');
    var response = await Dio().post(
      'http://10.0.2.2:3000/user',
      data: {'refreshToken': refreshToken},
      options: Options(validateStatus: ((status) {
        return status! < 500;
      })),
    );

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
        initialRoute = '/doctorMain';
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
    } else {
      await storage.deleteAll();
    }
  }
  runApp(MyApp(
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification!.body);
      }
    });

    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        NotificationApi().showNotification(
            title: message.notification!.title,
            body: message.notification!.body);
      }
    });

    // When running on background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.notification!.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aveksha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: widget.initialRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
