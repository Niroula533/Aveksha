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

  Future addReminder({
    required int timesPerDay,
    required DateTime dateTime,
    required String medName,
    required String dosage,
    required context,
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
    allMedicine.refresh();
    // AllReminders().update();
    for (int i = 0; i < allMedicine.last.med.doses.length; i++) {
      await NotificationApi().showScheduledNotification(
          scheduledDate: sortedTime[i],
          title: "Medicine Remind!",
          body: "Its time to take your medicine $medName.",
          payload: "/patientMain " +
              (allMedicine.length - 1).toString() +
              " " +
              i.toString() +
              " " +
              response.data['id'],
          id: (allMedicine.length - 1) * 6 + i);
    }
  }

  updateReminder({
    required reminderIndex,
    required int doseIndex,
    required reminderId,
  }) async {
    bool changedPrevious = false;
    allMedicine[reminderIndex].med.doses[doseIndex].isTaken = 1;
    if ((doseIndex - 1) != -1 &&
        allMedicine[reminderIndex].med.doses[doseIndex - 1].isTaken == 0) {
      allMedicine[reminderIndex].med.doses[doseIndex - 1].isTaken == -1;
      changedPrevious = true;
    }
    await Dio().post('http://10.0.2.2:3000/user/updateReminder', data: {
      "reminderId": reminderId,
      "doseIndex": doseIndex,
      "changedPrevious": changedPrevious
    });
    allMedicine.refresh();
  }

  delReminder({required id, required context}) async {
    int index = allMedicine.indexWhere((element) => element.id == id);
    for (int i = 0; i < allMedicine[index].med.doses.length; i++) {
      int notificationId = index * 6 + i;
      await NotificationApi.unScheduleNotification(id: notificationId);
    }
    print(id);
    String msg = await deleteReminder(id);
    allMedicine.removeWhere((element) => element.id == id);
    allMedicine.refresh();
    // AllReminders().update();
    if (msg.isNotEmpty) {
      final snack = SnackBar(
        content: Text(msg),
      );
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    update();
  }
}
