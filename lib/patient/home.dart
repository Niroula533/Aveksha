import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './components/tab_component.dart';
import 'components/med_component.dart';

class PatientHome extends StatefulWidget {
  PatientHome({Key? key}) : super(key: key);

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var allMedicine = [];
  updateAllMedicine(String name, String dosage, int timesPerDay, int startHour,
      int startMinute) {
    List<int> taken = List.generate(timesPerDay, (index) => 0);
    List<int> hours =
        List.generate(timesPerDay, (i) => (startHour * (i + 1)) % 24);
    hours.sort();
    setState(() {
      allMedicine.add(Medicine(
        name: name,
        taken: taken,
        dosage: dosage,
        hours: hours,
        minute: startMinute,
      ));
    });
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            var _textEditingController = TextEditingController();
            var _timesPerDayController = TextEditingController(text: '1');
            var _startTimeHourController = TextEditingController(text: '00');
            var _startTimeMinuteController = TextEditingController(text: '00');
            var _dosageController = TextEditingController();

            return AlertDialog(
              title: Text("ADD REMINDER"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text("Medicine Name: "),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _textEditingController,
                            validator: (value) {
                              return value!.isEmpty ? null : "Required";
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Medicine',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Dosage : "),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _dosageController,
                            validator: (value) {
                              return value!.isEmpty ? null : "Required";
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter dose (optional)',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                          child: Text("How often would you take the med? ")),
                      Expanded(
                          child: IconButton(
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
                      )),
                      Expanded(
                        child: TextFormField(
                          controller: _timesPerDayController,
                          validator: (v) => num.tryParse(v.toString()) == null
                              ? "Invalid Field"
                              : null,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[1-6]')),
                          ],
                        ),
                      ),
                      Expanded(
                          child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          var number = _timesPerDayController.text;
                          String n = (num.parse(number).toInt() + 1).toString();
                          _timesPerDayController.value = TextEditingValue(
                            text: n,
                            selection: TextSelection.fromPosition(
                              TextPosition(offset: n.length),
                            ),
                          );
                        },
                      )),
                      Expanded(child: Text("times per day")),
                    ]),
                    Row(children: [
                      Expanded(child: Text("Set time for the starting dose")),
                      Expanded(
                          child: TextFormField(
                              controller: _startTimeHourController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  _startTimeHourController.value =
                                      TextEditingValue(
                                    text: 00.toString(),
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: 2),
                                    ),
                                  );
                                } else if (num.parse(value.toString()) > 23 &&
                                    value.length > 2) {
                                  _startTimeHourController.value =
                                      TextEditingValue(
                                    text: 00.toString(),
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: 2),
                                    ),
                                  );
                                }
                              })),
                      Expanded(child: Text(" : ")),
                      Expanded(
                          child: TextFormField(
                        controller: _startTimeMinuteController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _startTimeMinuteController.value = TextEditingValue(
                              text: 00.toString(),
                              selection: TextSelection.fromPosition(
                                TextPosition(offset: 2),
                              ),
                            );
                          } else if (num.parse(value.toString()) > 59) {
                            _startTimeMinuteController.value = TextEditingValue(
                              text: 59.toString(),
                              selection: TextSelection.fromPosition(
                                TextPosition(offset: 2),
                              ),
                            );
                          }
                        },
                      )),
                    ])
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
            );
          });
        });
  }

  List<PopupMenuItem> menuItems = [
    PopupMenuItem(child: Text("Edit Profile")),
    PopupMenuItem(child: Text("Sign Out"))
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          color: const Color(0xFFE1EBF1),
          padding: EdgeInsets.symmetric(
              vertical: height * 0.05, horizontal: width * 0.04),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: height * 0.095,
                          width: height * 0.095,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "HELLO END",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.black,
                              ),
                            ),
                            Text("GOOD MORNING!"),
                          ],
                        ),
                      )
                    ],
                  ),
                  PopupMenuButton(itemBuilder: (context) => [...menuItems])
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("Sushant Adhikari, 21"),
                  Text("Dhulikhel, Kavre"),
                  Text("sushantadhikari2001@gmail.com"),
                  Text("+977 9815167761"),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  TabComponent(name: "MED"),
                  TabComponent(name: "EHR"),
                  TabComponent(name: "DOC"),
                ],
              ),
              SizedBox(
                height: height * 0.06,
              ),
              Expanded(
                child: ListView(
                  children: [
                    // Medicine(
                    //     name: "Para-Cetamol", dosage: 50, taken: [-1, 1, 0]),
                    // Medicine(
                    //     name: "Para-Cetamol", dosage: 50, taken: [-1, 1, 0]),
                    // Medicine(
                    //     name: "Para-Cetamol", dosage: 50, taken: [-1, 1, 0]),
                    // Medicine(
                    //     name: "Para-Cetamol", dosage: 50, taken: [-1, 1, 0]),
                    // Medicine(
                    //     name: "Para-Cetamol", dosage: 50, taken: [-1, 1, 0]),
                    // Medicine(
                    //     name: "Para-Cetamol", dosage: 50, taken: [-1, 1, 0]),
                    ...allMedicine
                  ],
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: height * 0.775,
          left: width * 0.9,
          child: FloatingActionButton(
            onPressed: () async {
              await showInformationDialog(context);
            },
            backgroundColor: Color(0xFF60BBFE).withOpacity(0.75),
            child: Icon(Icons.add, color: Colors.white, size: 32),
          ),
        )
      ],
    );
  }
}
