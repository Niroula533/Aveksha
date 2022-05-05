import 'dart:convert';

import 'package:aveksha/apis/flutter_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../patient/components/med_component.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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

class AllReminders extends GetxController {
  var allMedicine = <Medicine>[].obs;
  bool play = false;

  @override
  void onInit() {
    super.onInit();
    getAllReminders();
  }

  getAllReminders() async {
    var allReminder = await getReminder();
    allMedicine.value = allReminder.map((v) {
      List<DoseTime> dts = List.generate(v['doseTime'].length, (index) {
        return DoseTime(
            v['doseTime'][index]['isTaken'], v['doseTime'][index]['time']);
      });
      Meds med = Meds(v['name'], v['dosage'], dts);
      return Medicine(
        id: v['_id'],
        med: med,
      );
    }).toList();
  }

  // addReminder({required Meds med, required id}) {
  //   allMedicine.add(Medicine(med: med, id: id));
  // }

  Future addReminder({
    required int timesPerDay,
    required DateTime dateTime,
    required String medName,
    required String dosage,
    required BuildContext context,
  }) async {
    int interval = (24 / timesPerDay).truncate();
    var tempTime = dateTime;
    List<DateTime> sortedTime = List.generate(timesPerDay, (index) {
      var t = tempTime.add(Duration(hours: index * interval));
      return t;
    });
    sortedTime.sort(((a, b) => a.hour.compareTo(b.hour)));
    List<DoseTime> doseTime = List.generate(timesPerDay, ((index) {
      return DoseTime(0, DateFormat.Hm().format(sortedTime[index]));
    }));

    Meds med = Meds(medName, dosage, doseTime);
    var encodedMed = jsonEncode(med);
    Navigator.of(context).pop();
    var storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    var response = await Dio().post('http://10.0.2.2:3000/user/reminder',
        data: {'reminder': encodedMed, 'accessToken': accessToken});
    allMedicine.add(Medicine(med: med, id: response.data['id']));
    for (int i = 0; i < allMedicine.last.med.doses.length; i++) {
      NotificationApi().showScheduledNotification(
          scheduledDate: sortedTime[i],
          title: "Medicine Remind!",
          body: "Its time to take your medicine $medName.",
          id: (allMedicine.length - 1) * 6 + i);
    }
    print(await NotificationApi.showNumbers());
    allMedicine.refresh();
    AllReminders().update();
  }

  delReminder({required id, required context}) async {
    int index = allMedicine.indexWhere((element) => element.id == id);
    for (int i = 0; i < allMedicine[index].med.doses.length; i++) {
      int notificationId = index * 6 + i;
      await NotificationApi.unScheduleNotification(id: notificationId);
    }

    String msg = await deleteReminder(id);
    allMedicine.removeWhere((element) => element.id == id);
    if (msg.isNotEmpty) {
      //   Get.showSnackbar(GetSnackBar(
      //   message: "Deleted Successfully!",
      // ));
      final snack = SnackBar(
        content: Text(msg),
      );
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    print(await NotificationApi.showNumbers());
  }
}
