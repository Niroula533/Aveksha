import 'package:get/get.dart';

class UserInfo extends GetxController {
  String firstName = '',
      lastName = '',
      email = '',
      address = '',
      dob = '',
      gender = '',
      speciality = '';
  bool confirmed = false;
  int role = -1, phone = 0, nmc = 0;
  updateInfo(
      {firstName,
      lastName,
      email,
      phone,
      role,
      address,
      dob,
      gender,
      nmc,
      speciality,
      confirmed}) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (email != null) this.email = email;
    if (phone != null) this.phone = phone;
    if (role != null) this.role = role;
    if (address != null) this.address = address;
    if (dob != null) this.dob = dob;
    if (gender != null) this.gender = gender;
    if (nmc != null) this.nmc = nmc;
    if (speciality != null) this.speciality = speciality;
    if (confirmed != null) this.confirmed = confirmed;
  }
}
