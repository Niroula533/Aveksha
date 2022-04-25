import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/display_specialities.dart';
import 'components/display_listOfDoctor.dart';

// http: ^0.12.0+4 --- Add this is pubspec.yaml file


class PatientSearch extends StatefulWidget {
  const PatientSearch({Key? key}) : super(key: key);

  @override
  State<PatientSearch> createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearch> {

  List fooList = ['one', 'two', 'three', 'four', 'five', 'two', 'three', 'four', 'five', 'two', 'three', 'four', 'five'];
  List filteredList = [];

  // for clearing the textfield when tapped outside
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  updateFilteredList() {
    setState(() {
      filteredList = fooList;
    });
  }

  updateUnfilteredlist(){
    setState(() {
      filteredList.clear();
    });
  }

  void filter(String inputString) {
    filteredList =
        fooList.where((i) => i.toLowerCase().contains(inputString)).toList();
        setState(() {});
  }

  bool show(){
    return filteredList.isEmpty ;
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
                  padding: EdgeInsets.fromLTRB(40, 2, 30, 2)
              ),
            )
        ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          // _controller.clear();
          updateUnfilteredlist();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 228, 234, 235),
          ),

          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 15, 30, 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    prefixIcon: Icon(Icons.search_rounded),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54 , width: 32.0),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
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
              show() ? Expanded(child: Specialities()) : Expanded(
                child: ListView.separated(
                  itemCount: filteredList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage('https://ibb.co/TYfBk7q')
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(filteredList[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Display_Doctor( specialization: filteredList[index]),
                            ),
                          );
                        },
                      ), separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 5,child: Divider(),); },

                ),
              ),
            ],
          ),
        ),
      )
    );
}
}






