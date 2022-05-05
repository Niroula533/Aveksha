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
    doctors.value = response.data['doctors'].map<DocOrLab>((value) => DocOrLab(
        firstName: value['firstName'],
        hospital: value['hospital'],
        speciality: value['speciality'],
        id: value['userId'], role: 1)).toList();
    labTechs.value = response.data['labTechs'].map<DocOrLab>((value) => DocOrLab(
        firstName: value['firstName'],
        hospital: value['hospital'],
        speciality: value['speciality'],
        id: value['userId'], role: 2)).toList();
  }
}
