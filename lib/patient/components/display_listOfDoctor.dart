import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'prescriptionForm.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class Display_Doctor extends StatefulWidget {
   Display_Doctor({Key? key,required this.specialization}) : super(key: key);

  String specialization;

  @override
  State<Display_Doctor> createState() => _Display_DoctorState();
}

class _Display_DoctorState extends State<Display_Doctor> {

  var details = <Map<String,dynamic>>[
    {
      'Username': 'Sonam Adhikari',
      'specialization': 'General Physician',
      'rating': 3,
      'works-at': 'Om hospital',
      'consultation_fee': '500',
      'Next_Available_at': '9:00 AM'
    },
    {
      'Username': 'Jacki Lhowa',
      'specialization': 'Optician',
      'rating': 3,
      'works-at': 'Bir hospital',
      'consultation_fee': '800',
      'Next_Available_at': '10:00 AM'
    },
    {
      'Username': 'Manoj Adhikari',
      'specialization': 'Surgeon',
      'rating': 3,
      'works-at': 'Laxmi Hospital',
      'consultation_fee': '400',
      'Next_Available_at': '9:00 AM'
    },
    {
    'Username': 'Alisha Chettri',
    'specialization': 'Neurologist',
    'rating': 3,
    'works-at': 'Dhulikhel hospital',
    'consultation_fee': '800',
    'Next_Available_at': '10:00 AM'
    },
    {
    'Username': 'Ayush Aryal',
    'specialization': 'Gynaecologist',
    'rating': 3,
    'works-at': 'Dhir Hospital',
    'consultation_fee': '400',
    'Next_Available_at': '9:00 AM'
    },
  ];



  final String apiUrl = "https://randomuser.me/api/?results=5";

  Future<List<dynamic>> fetchSpecialities() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['name']['title'] +
        " " +
        user['name']['first'] +
        " " +
        user['name']['last'];
  }


  @override
  Widget build(BuildContext context) {
    print(widget.specialization);

    void _showRatingAppDialog() {
      final _ratingDialog = RatingDialog(
        // ratingColor: Colors.amber,
        title: Text('Please rate your experience',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold )),
        message: const Text('your feed back will be displayed in the profile of Doctor',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15 )),
        image: Image.asset("images/IconOnly.png",
          height: 100,),
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



    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: FutureBuilder<List<dynamic>>(
              future: fetchSpecialities(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Result for ', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Display(
                              //       text: 'this is the profile of Doctor',
                              //     ),
                              //   ),
                              // );

                              //this is for Prescription form
                              // Navigator.pushNamed(context, '/prescriptionForm');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Prescription( ),

                                ),
                              );

                            },
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(snapshot.data[index]['picture']['large'])),
                                      title: Text(details[index]['Username']),
                                      subtitle: Text(details[index]['specialization']),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Works at ' + details[index]['works-at'],style: TextStyle(color: Colors.grey)),
                                              Text('NPR : ' + details[index]['consultation_fee'] + ' consultation fee',style: TextStyle(color: Colors.grey)),
                                              SizedBox(height: 8,),
                                              Text('Next Available at ',style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)),
                                              Text(details[0]['Next_Available_at'],style: TextStyle(color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: InkWell(
                                            onTap: _showRatingAppDialog,
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.green[800],
                                                borderRadius: BorderRadius.circular(20)
                                              ),

                                              child: const Center(child: Text('Book Appoinment',style: TextStyle(color: Colors.white))),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15,)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ))
          ],
        ),
      )
    );Container();
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
