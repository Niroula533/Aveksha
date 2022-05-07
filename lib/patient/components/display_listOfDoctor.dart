import 'package:aveksha/comp/navigation_bar.dart';
import 'package:aveksha/controllers/doctorControl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'prescriptionForm.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Speciality_Doctor extends StatefulWidget {
  Speciality_Doctor(
      {Key? key, required this.specialization, required this.isDoctor})
      : super(key: key);

  String specialization;
  bool isDoctor = true;

  @override
  State<Speciality_Doctor> createState() => _Speciality_DoctorState();
}

class _Speciality_DoctorState extends State<Speciality_Doctor> {
  @override
  void initState() {
   // print(Get.find<ListOfDoctorsAndLabtech>().labTechs[0].firstName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var specializedDoctorsOrTechnicians = widget.isDoctor
        ? Get.find<ListOfDoctorsAndLabtech>()
            .doctors
            .where((p0) => p0.speciality == widget.specialization)
            .toList()
        : Get.find<ListOfDoctorsAndLabtech>()
            .labTechs
            .where((p0) => p0.speciality == widget.specialization)
            .toList();

    void _showRatingAppDialog() {
      final _ratingDialog = RatingDialog(
        // ratingColor: Colors.amber,
        title: Text('Please rate your experience',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        message: const Text(
            'your feed back will be displayed in the profile of Doctor',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15)),
        image: Image.asset(
          "images/IconOnly.png",
          height: 100,
        ),
        submitButtonText: 'Submit',
        commentHint: 'Leave a review ',
        onCancelled: () => print('cancelled'),
        onSubmitted: (response) {
          print('rating: ${response.rating}, '
              'comment: ${response.comment}');
        },
      );

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => _ratingDialog,
      );
    }

    var speciality = widget.specialization;
    return Scaffold(
        body: Container(
      color: const Color(0xFFE1EBF1),
      child: Column(
        children: [
          Expanded(
              child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Result for $speciality",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: specializedDoctorsOrTechnicians.length,
                itemBuilder: (BuildContext context, int index) {
                  print(specializedDoctorsOrTechnicians[index].firstName);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/patientToOther',
                          arguments: specializedDoctorsOrTechnicians[index]);
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                  radius: 30, backgroundImage: null),
                              title: Text(specializedDoctorsOrTechnicians[index]
                                  .firstName),
                              subtitle: Text(
                                  specializedDoctorsOrTechnicians[index]
                                      .speciality),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 5, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Works at ' +
                                              specializedDoctorsOrTechnicians[
                                                      index]
                                                  .hospital,
                                          style: TextStyle(color: Colors.grey)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: null,
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.green[800],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Center(
                                          child: Text('Book Appoinment',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ))
        ],
      ),
    ));
  }
}

class Display extends StatelessWidget {
  final String text;

  const Display({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}


// [
// Expanded(child: FutureBuilder<List<dynamic>>(
// future: fetchSpecialities(),
// builder: (BuildContext context, AsyncSnapshot snapshot) {
// if (snapshot.hasData) {
// return ListView(
// scrollDirection: Axis.vertical,
// shrinkWrap: true,
// children: [
// const Padding(
// padding: EdgeInsets.all(10.0),
// child: Text('Result for general Physician', style: TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 18,
// ),),
// ),
// ListView.builder(
// padding: EdgeInsets.all(8),
// shrinkWrap: true,
// physics: NeverScrollableScrollPhysics(),
// itemCount: snapshot.data.length,
// itemBuilder: (BuildContext context, int index) {
// return InkWell(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => Display(
// text: 'This is the card',
// ),
// ),
// );
// },
// child: Card(
// child: Column(
// children: <Widget>[
// ListTile(
// leading: CircleAvatar(
// radius: 30,
// backgroundImage: NetworkImage(snapshot.data[index]['picture']['large'])),
// title: Text(_name(snapshot.data[index])),
// )
// ],
// ),
// ),
// );
// },
// ),
// ],
// );
// } else {
// return Center(child: CircularProgressIndicator());
// }
// },
// ))
// ],


// showModalBottomSheet<void>(
// context: context,
// builder: (BuildContext context) {
// return Container(
// height: 400,
// color: Colors.amber,
// child: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// mainAxisSize: MainAxisSize.min,
// children: <Widget>[
// const Text('Please rate your experience'),
//
// ElevatedButton(
// child: const Text('Close BottomSheet'),
// onPressed: () => Navigator.pop(context),
// )
// ],
// ),
// ),
// );
// },
// );
