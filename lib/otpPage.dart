import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:dio/dio.dart';

class OtpPage extends StatefulWidget {
  // final String email;
  // OtpPage({Key? key, required this.email}) : super(key: key);
  OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: Container(
                // child: Image.asset('image/aveksha_logo.png'),
                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Image.asset('images/aveksha_logo.png',
                    height: 100, width: 200),
                padding: EdgeInsets.all(5.0)),
          )),
      body: Center(
        child: OTPTextField(
          length: 6,
          width: MediaQuery.of(context).size.width,
          fieldWidth: 80,
          style: TextStyle(fontSize: 17),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.underline,
          onCompleted: (pin) async {
            // var response = await Dio().post('http://localhost:5000/otpcheck',
            // data: {'otp': pin, 'email': widget.email});
            // if (response.data['msg'] == "Account is verified") {
            Navigator.of(context).pushNamed('/patientMain');
            // }
          },
        ),
      ),
    );
  }
}
