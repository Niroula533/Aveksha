import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:aveksha/controllers/hrControl.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:pattern_formatter/date_formatter.dart';

Future<void> addHealthRecords(
  BuildContext context,
) async {
  final formKey = GlobalKey<FormState>();
  var _titleController = TextEditingController();
  Widget _file = Text("No File Selected!");
  var _dateTime = DateTime.now();
  var file;
  const String cloudinaryCustomFolder = "aveksha/hr";
  const String cloudinaryApiKey = "972485551671114";
  const String cloudinaryApiSecret = "uWGoNjtRS-ClDnjkqtR8ltF78Ho";
  const String cloudinaryCloudName = "foodfinder";
  Cloudinary cloudinary =
      Cloudinary(cloudinaryApiKey, cloudinaryApiSecret, cloudinaryCloudName);

  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: AlertDialog(
              scrollable: true,
              backgroundColor: Color.fromARGB(242, 255, 255, 255),
              title: Text("Add Health Records"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        return value!.isEmpty ? "Required" : null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Record Title',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    Text(
                      "Files to Upload:",
                      style: TextStyle(color: Color(0xFF1EA3EA)),
                    ),
                    _file,
                    TextButton(
                        onPressed: () async {
                          file = await FilePicker.platform
                              .pickFiles(allowMultiple: false);
                          // a.files;
                          if (file == null) {
                            _file = Text("No File Selected!");
                            return;
                          } else {
                            file = File(file.files.first.path);
                            setState(() => _file = buildFile(file,
                                MediaQuery.of(context).size.width * 0.3));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Upload Files",
                                  style: TextStyle(color: Color(0xFFFF667E)))),
                        )),
                    Text(
                      "Record issued Date:",
                      style: TextStyle(color: Color(0xFF1EA3EA)),
                    ),
                    SizedBox(
                      height: 80,
                      child: CupertinoDatePicker(
                          initialDateTime: _dateTime,
                          mode: CupertinoDatePickerMode.date,
                          maximumDate: DateTime.now(),
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
                      if (file != null) {
                        var fileName =
                            file.path.split('/').last + _dateTime.toString();
                        var response = await cloudinary.uploadFile(
                            filePath: file.path,
                            fileName: fileName,
                            folder: cloudinaryCustomFolder,
                            resourceType: CloudinaryResourceType.auto);
                        var date = DateFormat.yMd().format(_dateTime);
                        Get.find<AllHR>().addHr(
                            title: _titleController.text,
                            url: response.url!,
                            date: date);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Add")),
              ],
            ),
          );
        });
      });
}

Widget buildFile(File file, width) {
  final path = file.path;
  final fileName = path.split('/').last;
  final extension = fileName.split('.').last;

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 50,
            width: width,
            color: Color(0xFF1EA3EA),
            child: Center(
                child: Text(
              ".$extension",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
        Text(
          "$fileName",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}

Widget searchHealthRecords(BuildContext context,
    TextEditingController _startDate, TextEditingController _endDate) {
  return Obx(() {
    return Get.find<AllHR>().allHr.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextField(
                        controller: _startDate,
                        inputFormatters: [DateInputFormatter()],
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'Start Date',
                        ),
                        onTap: () async {
                          DateTime? _dateTime;
                          _dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateFormat.yMd()
                                  .parse(Get.find<AllHR>().allHr.first.date),
                              firstDate: DateFormat.yMd()
                                  .parse(Get.find<AllHR>().allHr.first.date),
                              lastDate: DateFormat.yMd()
                                  .parse(Get.find<AllHR>().allHr.last.date));

                          String stringDate =
                              Get.find<AllHR>().allHr.first.date;
                          if (_dateTime != null) {
                            stringDate = DateFormat.yMd().format(_dateTime);
                          }
                          _startDate.text = stringDate;
                        }),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextField(
                        controller: _endDate,
                        inputFormatters: [DateInputFormatter()],
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'End Date',
                        ),
                        onTap: () async {
                          DateTime? _dateTime;
                          _dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateFormat.yMd()
                                  .parse(Get.find<AllHR>().allHr.last.date),
                              firstDate: DateFormat.yMd()
                                  .parse(Get.find<AllHR>().allHr.first.date),
                              lastDate: DateFormat.yMd()
                                  .parse(Get.find<AllHR>().allHr.last.date));

                          String stringDate = Get.find<AllHR>().allHr.last.date;
                          if (_dateTime != null) {
                            stringDate = DateFormat.yMd().format(_dateTime);
                          }
                          _endDate.text = stringDate;
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(14),
              //   child: TextButton(
              //       style: ButtonStyle(
              //         padding: MaterialStateProperty.all<EdgeInsets>(
              //             EdgeInsets.all(2.5)),
              //         backgroundColor:
              //             MaterialStateProperty.all<Color>(Color(0xFF60BBFE)),
              //       ),
              //       onPressed: null,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           'SEARCH',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 20,
              //               fontWeight: FontWeight.w900,
              //               letterSpacing: 1.1),
              //         ),
              //       )),
              // )
            ],
          )
        : Container(
            child: Text("No HR added yet!"),
          );
  });
}
