import 'package:aveksha/controllers/userControl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class SignUp {
//   final String firstName, lastName, email, password, address,role;
//   String DOB = '', nmc = '';
//   SignUp(this.firstName, this.lastName, this.email,this.role, this.password, this.address,
//       DOB, nmc){

//       }
// }

Future<dynamic> handleRegister(
    {required context,
    required fullName,
    required email,
    required contact,
    required pass,
    required address,
    pickedDate,
    gender,
    required role,
    nmc}) async {
  try {
    final storage = FlutterSecureStorage();
    List<String> name = fullName.split(' ');
    var response;
    if (role == 0) {
      response = await Dio().post('http://10.0.2.2:3000/user/register', data: {
        'firstName': name[0],
        'lastName': name[1],
        'email': email,
        'phone': num.parse(contact),
        'password': pass,
        'role': role,
        'address': address,
        'DOB': pickedDate,
        'gender': gender,
      }, options: Options(
        validateStatus: (status) {
          return num.parse(status.toString()).toInt() < 500;
        },
      ));
    } else if (role == 1) {
      response = await Dio().post('http://10.0.2.2:3000/user/register', data: {
        'firstName': name[0],
        'lastName': name[1],
        'email': email,
        'phone': num.parse(contact),
        'password': pass,
        'role': role,
        'address': address,
        'nmc': nmc
      }, options: Options(
        validateStatus: (status) {
          return num.parse(status.toString()).toInt() < 500;
        },
      ));
    } else {
      response = await Dio().post('http://10.0.2.2:3000/user/register', data: {
        'firstName': name[0],
        'lastName': name[1],
        'email': email,
        'phone': num.parse(contact),
        'password': pass,
        'role': role,
        'address': address,
      }, options: Options(
        validateStatus: (status) {
          return num.parse(status.toString()).toInt() < 500;
        },
      ));
    }

    if (response.data['msg'] == 'Registered successfully!') {
      Get.find<UserInfo>().updateInfo(
          firstName: name[0],
          lastName: name[1],
          email: email,
          phone: num.parse(contact),
          role: role,
          address: address,
          dob: pickedDate,
          nmc: nmc,
          gender: gender);
      await storage.write(key: 'role', value: role.toString());
      await storage.write(
          key: "accessToken", value: response.data["accessToken"]);
      await storage.write(
          key: "refreshToken", value: response.data["refreshToken"]);
      Navigator.of(context).pushNamed('/otp', arguments: email);
      return '';
    } else {
      // return response.data["msg"];
      var h = response.data["msg"];
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Registration unsuccessfull!"),
              content: Text(h),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Retry")),
                TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child: Text("LogIn"))
              ],
            );
          });
    }
  } catch (e) {
    return e.toString();
  }
}
