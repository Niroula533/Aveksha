import 'package:aveksha/controllers/doctorControl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/display_specialities.dart';

// http: ^0.12.0+4 --- Add this is pubspec.yaml file

class PatientSearch extends StatefulWidget {
  final updateIndex;
  PatientSearch({Key? key, required this.updateIndex}) : super(key: key);

  @override
  State<PatientSearch> createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearch> {
  List fooList = [
    ...Get.find<ListOfDoctorsAndLabtech>().doctors,
    ...Get.find<ListOfDoctorsAndLabtech>().labTechs
  ];
  List filteredList = [];

  // for clearing the textfield when tapped outside
  TextEditingController _controller = TextEditingController();

  updateFilteredList() {
    setState(() {
      filteredList = fooList;
    });
  }

  updateUnfilteredlist() {
    setState(() {
      filteredList.clear();
    });
  }

  void filter(String inputString) {
    if (inputString.isEmpty) {
      updateUnfilteredlist();
    } else {
      setState(() {
        filteredList = fooList
            .where((i) =>
                i.firstName.toLowerCase().contains(inputString) ||
                i.speciality.toLowerCase().contains(inputString))
            .toList();
      });
    }
  }

  bool show() {
    return filteredList.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 228, 234, 235),
            elevation: 0,
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/registration');
              },
              child: Container(
                  // child: Image.asset('image/aveksha_logo.png'),
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Image.asset('images/aveksha_logo.png',
                      height: 100, width: 200),
                  padding: EdgeInsets.fromLTRB(40, 2, 30, 2)),
            )),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 228, 234, 235),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 15, 30, 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    prefixIcon: Icon(Icons.search_rounded),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white54, width: 32.0),
                        borderRadius: BorderRadius.circular(20.0)),
                    suffixIcon: IconButton(
                      onPressed: _controller.clear,
                      icon: Icon(Icons.clear),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  controller: _controller,
                  onChanged: (text) {
                    updateFilteredList;
                    text = text.toLowerCase();
                    filter(text);
                  },
                ),
              ),
              show()
                  ? Expanded(
                      child: Specialities(
                      updateIndex: widget.updateIndex,
                    ))
                  : Expanded(
                      child: ListView.separated(
                        itemCount: filteredList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage('https://ibb.co/TYfBk7q')),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(filteredList[index].firstName),
                          onTap: null,
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 5,
                            child: Divider(),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }
}
