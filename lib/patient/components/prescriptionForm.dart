import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Prescription extends StatefulWidget {
  const Prescription({Key? key}) : super(key: key);

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {

  DateTime dateToday =new DateTime.now();

  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleController.dispose();
    _detailsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    String date = dateToday.toString().substring(0,10);
    String time = dateToday.toString().substring(11,17);


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Patient\'s Prescription'),
        backgroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
          reverse: true,
        child: Column(

          children: <Widget>[

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(image: AssetImage("images/IconOnly.png"),height: 80,width: 80,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5,5,5,5),
                        child: Text('DATE : ${date}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5,5,5,5),
                        child: Text('TIME : ${time}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold )),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Divider(
                color: Colors.black
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
              child: TextFormField(
                controller: _titleController,
                maxLength: 15,
                maxLengthEnforced: false,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Title of the Prescription',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: TextFormField(
                controller: _detailsController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                minLines: 5,
                decoration: const InputDecoration(
                  filled: true,
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Details',
                  hintText: 'Details of Appointment',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                minLines: 5,
                decoration: const InputDecoration(
                  filled: true,
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Prescription',
                  hintText: 'Medical Prescription necessary for patient'
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Text(_descriptionController.text),


                      );
                    },
                  );
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(20)
                  ),

                  child: const Center(child: Text('Send',style: TextStyle(color: Colors.white,fontSize: 20))),
                ),
              ),
            )


          ],
    ),
      )
    );
  }
}
