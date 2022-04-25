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
                          file = await FilePicker.getFile();
                          if (file == null) {
                            _file = Text("No File Selected!");
                            return;
                          } else {
                            setState(() => _file = buildFile(
                                file, MediaQuery.of(context).size.width * 0.3));
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
                      // var response = await Dio().post(
                      //     'http://localhost:3000/hr',
                      //     data: {"file": file});
                      // print(response);
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
