import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../patient/components/med_component.dart';
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

  addReminder({required Meds med, required id}) {
    allMedicine.add(Medicine(med: med, id: id));
  }

  delReminder({required id, required BuildContext context}) async {
    allMedicine.removeWhere((element) => element.id == id);
    var msg = await deleteReminder(id);
    final snack = SnackBar(
      content: Text(msg),
    );
    Get.showSnackbar(GetSnackBar(
      message: 'Deleted Successfully',
    ));
  }
}
