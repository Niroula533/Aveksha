import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

Future<void> addReminder(
  BuildContext context,
  Function updateAllMedicine,
) async {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var _textEditingController = TextEditingController();
  var _timesPerDayController = TextEditingController(text: '1');
  var _startTimeHourController = TextEditingController(text: '00');
  var _startTimeMinuteController = TextEditingController(text: '00');
  var _dosageController = TextEditingController();
  var _scrollController = ScrollController();
  
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
                        return value!.isEmpty ? null : "Required";
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Medicine',
                      ),
                    ),
                    TextFormField(
                      controller: _dosageController,
                      validator: (value) {
                        return value!.isEmpty ? null : "Required";
                      },
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
                              validator: (v) =>
                                  num.tryParse(v.toString()) == null
                                      ? "Invalid Field"
                                      : null,
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
                    Center(
                      child: Row(
                        children: [
                          SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Text('1'),
                                Text('1'),
                                Text('1'),
                              ],
                            ),
                          ),
                          Expanded(child: Text(" : ")),
                          Expanded(
                              child: TextFormField(
                            controller: _startTimeMinuteController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _startTimeMinuteController.value =
                                    TextEditingValue(
                                  text: 00.toString(),
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: 2),
                                  ),
                                );
                              } else if (num.parse(value.toString()) > 59) {
                                _startTimeMinuteController.value =
                                    TextEditingValue(
                                  text: 59.toString(),
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: 2),
                                  ),
                                );
                              }
                            },
                          )),
                        ],
                      ),
                    ),
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
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        updateAllMedicine(
                            _textEditingController.text,
                            _dosageController.text,
                            num.parse(_timesPerDayController.text).toInt(),
                            num.parse(_startTimeHourController.text).toInt(),
                            num.parse(_startTimeMinuteController.text).toInt());
                        Navigator.of(context).pop();
                      } else {
                        return null;
                      }
                    },
                    child: Text("Add")),
              ],
            ),
          );
        });
      });
}
