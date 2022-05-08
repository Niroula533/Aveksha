import 'package:aveksha/controllers/userControl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Conformer extends StatelessWidget {
  const Conformer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Your account is not verified"),
          TextButton(
              onPressed: () async {
                String email = Get.find<UserInfo>().email;
                await Dio().post("http://10.0.2.2:3000/user/otpupdate",
                    data: {"email": email});
                Navigator.of(context).pushNamed("/otp");
              },
              child: Text("Verify"))
        ],
      ),
    );
  }
}
