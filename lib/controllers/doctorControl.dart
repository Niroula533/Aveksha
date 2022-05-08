import 'dart:ffi';

import 'package:aveksha/controllers/userControl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class DocOrLab {
  final String firstName, hospital, speciality, email;
  final id, role, phone;
  DocOrLab(
      {required this.firstName,
      required this.email,
      required this.hospital,
      required this.speciality,
      required this.id,
      required this.role,
      required this.phone});
}

class AppointMents {
  String patient_Name, doctor_Name, status, time, speciality;
  String? problem;
  bool? isDoctor;
  double? hour;
  var date, patient_phone;
  var doctor_id, id;
  AppointMents(
      {required this.patient_Name,
      required this.doctor_id,
      required this.doctor_Name,
      required this.id,
      required this.date,
      required this.time,
      this.hour,
      this.problem,
      required this.status,
      required this.speciality,
      required this.patient_phone,
      this.isDoctor});
}

class ListofAppointments extends GetxController {
  var appointments = <AppointMents>[].obs;
  var ownAppointments = <AppointMents>[].obs;

  

  Future getOwnAppointments() async {
    var storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "accessToken");
    int role = Get.find<UserInfo>().role;
    var response = await Dio().post(
        "http://10.0.2.2:3000/doctor/getAllAppointments",
        data: {"accessToken": accessToken, "role": role});

    ownAppointments.value = response.data.map<AppointMents>((value) {
      if (value['isDoctor'] != null && !value['isDoctor']) {
        return AppointMents(
            isDoctor: value['isDoctor'],
            patient_Name: value['patient_Name'],
            doctor_Name: value['doctor_Name'],
            speciality: value['speciality'],
            doctor_id: value['doctor_id'],
            date: value['date'],
            time: value['time'],
            status: value['status'],
            patient_phone: value['patient_phone'],
            id: value['_id']);
      } else {
        return AppointMents(
            isDoctor: value['isDoctor'],
            patient_Name: value['patient_Name'],
            doctor_Name: value['doctor_Name'],
            speciality: value['speciality'],
            doctor_id: value['doctor_id'],
            date: value['date'],
            time: value['time'],
            hour: double.parse(value['hour'].toString()),
            problem: value['problem'],
            status: value['status'],
            patient_phone: value['patient_phone'],
            id: value['_id']);
      }
    }).toList();
  }

  Future updateAppointments({required status, required id}) async {
    var response = await Dio().put(
        "http://10.0.2.2:3000/doctor/updateAppointments",
        data: {"id": id, "status": status});
    int index = appointments.indexWhere((element) => element.id == id);
    int index2 = ownAppointments.indexWhere((element) => element.id == id);
    appointments[index].status = status;
    ownAppointments[index2].status = status;
    appointments.refresh();
    ownAppointments.refresh();
  }

  Future getAppointments({id, required role, accessToken}) async {
    // var url = "http://10.0.2.2:3000/doctor/$id";
    var response = await Dio().post(
        "http://10.0.2.2:3000/doctor/getAllAppointments",
        data: {"id": id, "role": role, "accessToken": accessToken});

    appointments.value = response.data.map<AppointMents>((value) {
      if(value['isDoctor'] != null && !value['isDoctor']){
        return AppointMents(
        isDoctor: value['isDoctor'],
        id: value['_id'],
        patient_Name: value['patient_Name'],
        doctor_Name: value['doctor_Name'],
        speciality: value['speciality'],
        doctor_id: value['doctor_id'],
        date: value['date'],
        time: value['time'],
        patient_phone: value['patient_phone'],
        status: value['status'],
      );
      } else{
        return AppointMents(
        isDoctor: value['isDoctor'],
        id: value['_id'],
        patient_Name: value['patient_Name'],
        doctor_Name: value['doctor_Name'],
        speciality: value['speciality'],
        doctor_id: value['doctor_id'],
        date: value['date'],
        time: value['time'],
        hour: double.parse(value['hour'].toString()),
        problem: value['problem'],
        patient_phone: value['patient_phone'],
        status: value['status'],
      );
      }
      
    }).toList();
  }

  Future addAppointments(
      {required requestAppointment,
      required accessToken,
      required doctorId}) async {
    var response =
        await Dio().post('http://10.0.2.2:3000/doctor/addAppointment', data: {
      "accessToken": accessToken,
      "doctorId": doctorId,
      "requestAppointment": requestAppointment
    });
    ownAppointments.add(AppointMents(
        isDoctor: response.data['isDoctor'],
        patient_Name: requestAppointment['patient_Name'],
        doctor_id: doctorId,
        doctor_Name: requestAppointment['doctor_Name'],
        id: response.data['id'],
        date: requestAppointment['date'],
        time: requestAppointment['time'],
        hour: requestAppointment['hour'],
        problem: requestAppointment['problem'],
        patient_phone: requestAppointment['patient_phone'],
        status: requestAppointment['status'],
        speciality: requestAppointment['speciality']));
    appointments.add(AppointMents(
        isDoctor: response.data['isDoctor'],
        patient_Name: requestAppointment['patient_Name'],
        patient_phone: requestAppointment['patient_phone'],
        doctor_id: doctorId,
        doctor_Name: requestAppointment['doctor_Name'],
        id: response.data['id'],
        date: requestAppointment['date'],
        time: requestAppointment['time'],
        hour: requestAppointment['hour'],
        problem: requestAppointment['problem'],
        status: requestAppointment['status'],
        speciality: requestAppointment['speciality']));
    ownAppointments.refresh();
    appointments.refresh();
  }
}

class ListOfDoctorsAndLabtech extends GetxController {
  var doctors = <DocOrLab>[].obs;
  var labTechs = <DocOrLab>[].obs;

  @override
  onInit() {
    super.onInit();
    getDoctors();
  }

  Future getDoctors() async {
    var response = await Dio().get("http://10.0.2.2:3000/doctor");
    doctors.value = response.data['doctors']
        .map<DocOrLab>((value) => DocOrLab(
            firstName: value['firstName'],
            email: value['email'],
            phone: value['phone'],
            hospital: value['hospital'],
            speciality: value['speciality'],
            id: value['userId'],
            role: 1))
        .toList();
    labTechs.value = response.data['labTechs']
        .map<DocOrLab>((value) => DocOrLab(
            firstName: value['firstName'],
            email: value['email'],
            phone: value['phone'],
            hospital: value['hospital'],
            speciality: value['speciality'],
            id: value['userId'],
            role: 2))
        .toList();
  }
}
