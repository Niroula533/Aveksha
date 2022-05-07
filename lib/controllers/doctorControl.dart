import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DocOrLab {
  final String firstName, hospital, speciality;
  final id, role;
  DocOrLab(
      {required this.firstName,
      required this.hospital,
      required this.speciality,
      required this.id,
      required this.role});
}

class AppointMents {
  String patient_Name, problem, status, time;
  var hour;
  var date;
  var doctor_id, id;
  AppointMents(
      {required this.patient_Name,
      required this.doctor_id,
      required this.id,
      required this.date,
      required this.time,
      required this.hour,
      required this.problem,
      required this.status});
}

class ListofAppointments extends GetxController {
  var appointments = <AppointMents>[].obs;

  Future updateAppointments({id, required status, required index}) async {
    var response = await Dio().put(
        "http://10.0.2.2:3000/doctor/updateAppointments",
        data: {"id": id, "status": status});
    // print(status);
    appointments[index].status = status;
    appointments.refresh();
    print(appointments[index]);
  }

  Future getAppointments({id, required role, accessToken}) async {
    // var url = "http://10.0.2.2:3000/doctor/$id";
    var response = await Dio().post(
        "http://10.0.2.2:3000/doctor/getAllAppointments",
        data: {"id": id, "role": role, "accessToken": accessToken});

    appointments.value = response.data
        .map<AppointMents>((value) => AppointMents(
              id: value['_id'],
              patient_Name: value['patient_Name'],
              doctor_id: value['doctor_id'],
              date: value['date'],
              time: value['time'],
              hour: value['hour'],
              problem: value['problem'],
              status: value['status'],
            ))
        .toList();
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
            hospital: value['hospital'],
            speciality: value['speciality'],
            id: value['userId'],
            role: 1))
        .toList();
    labTechs.value = response.data['labTechs']
        .map<DocOrLab>((value) => DocOrLab(
            firstName: value['firstName'],
            hospital: value['hospital'],
            speciality: value['speciality'],
            id: value['userId'],
            role: 2))
        .toList();
  }
}
