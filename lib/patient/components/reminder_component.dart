import 'dart:convert';
import 'dart:ui';
import 'package:aveksha/controllers/reminderControl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/medicine_model.dart';

Future<void> addReminder(
  BuildContext context,
) async {
  final formKey = GlobalKey<FormState>();
  var _textEditingController = TextEditingController();
  var _timesPerDayController = TextEditingController(text: '1');
  var _dosageController = TextEditingController();
  var _dateTime = DateTime.now();

  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: AlertDialog(
              scrollable: true,
              backgroundColor: Color.fromARGB(242, 255, 255, 255),
              title: Text("ADD REMINDER"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _textEditingController,
                      validator: (value) {
                        print(value);
                        return value!.isEmpty ? "Required" : null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Medicine',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _dosageController,
                      // validator: (value) {
                      //   return value!.isEmpty ? null : "Required";
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter dose (optional)',
                      ),
                    ),
                    Text(
                      "How often would you take the med?",
                      style: TextStyle(color: Color(0xFF1EA3EA)),
                    ),
                    Center(
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              var number = _timesPerDayController.text;
                              int v = num.parse(number).toInt() - 1;
                              String n = "1";
                              if (v > 1) {
                                n = v.toString();
                              }
                              _timesPerDayController.value = TextEditingValue(
                                text: n,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: n.length),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _timesPerDayController,
                              // validator: (v) =>
                              //     num.tryParse(v.toString()) == null
                              //         ? "Invalid Field"
                              //         : null,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[1-6]')),
                              ],
                            ),
                          ),
                          Expanded(
                              child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              var number = _timesPerDayController.text;
                              String n =
                                  (num.parse(number).toInt() + 1).toString();
                              _timesPerDayController.value = TextEditingValue(
                                text: n,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: n.length),
                                ),
                              );
                            },
                          )),
                          Text("times per day"),
                        ],
                      ),
                    ),
                    Text(
                      "Set time for the starting dose",
                      style: TextStyle(color: Color(0xFF1EA3EA)),
                    ),
                    SizedBox(
                      height: 80,
                      child: CupertinoDatePicker(
                          initialDateTime: _dateTime,
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (dateTime) {
                            setState(() {
                              _dateTime = dateTime;
                            });
                          }),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      int timesPerDay =
                          num.parse(_timesPerDayController.text).toInt();

                      if (formKey.currentState!.validate()) {
                        int interval = (24 / timesPerDay).truncate();
                        var tempTime = _dateTime;
                        List<DateTime> sortedTime =
                            List.generate(timesPerDay, (index) {
                          var t =
                              tempTime.add(Duration(hours: index * interval));
                          return t;
                        });
                        sortedTime.sort(((a, b) => a.hour.compareTo(b.hour)));
                        List<DoseTime> doseTime =
                            List.generate(timesPerDay, ((index) {
                          return DoseTime(
                              0, DateFormat.Hm().format(sortedTime[index]));
                        }));

                        Meds med = Meds(_textEditingController.text,
                            _dosageController.text, doseTime);
                        var encodedMed = jsonEncode(med);
                        Navigator.of(context).pop();
                        var storage = FlutterSecureStorage();
                        final accessToken =
                            await storage.read(key: 'accessToken');
                        var response = await Dio()
                            .post('http://10.0.2.2:3000/user/reminder', data: {
                          'reminder': encodedMed,
                          'accessToken': accessToken
                        });
                        Get.find<AllReminders>()
                            .addReminder(med: med, id: response.data['id']);
                        Get.find<AllReminders>().refresh();
                      }
                    },
                    child: Text("Add")),
              ],
            ),
          );
        });
      });
}
