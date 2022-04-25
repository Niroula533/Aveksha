import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:photo_view/photo_view.dart';

Future<List> getHR() async {
  final storage = FlutterSecureStorage();
  var accessToken = await storage.read(key: 'accessToken');
  var response = await Dio()
      .post('http://10.0.2.2:3000/hr/get', data: {'accessToken': accessToken});
  if (response.data['hr'] != null) {
    return response.data['hr'];
  } else {
    return [];
  }
}

Future<dynamic> addHR(
    {required String title, required String date, required String url}) async {
  final storage = FlutterSecureStorage();
  var accessToken = await storage.read(key: 'accessToken');
  var response = await Dio().post('http://10.0.2.2:3000/hr/add', data: {
    "title": title,
    "url": url,
    "date": date,
    "accessToken": accessToken
  });
  return response.data;
}

Future<String> delHR({required final id}) async {
  final storage = FlutterSecureStorage();
  var accessToken = await storage.read(key: 'accessToken');
  var response = await Dio().post('http://10.0.2.2:3000/hr/delete',
      data: {"id": id, "accessToken": accessToken});
  return response.data['msg'];
}

class HR extends StatelessWidget {
  final String date;
  List<Reports> reports;
  HR({Key? key, required this.date, required this.reports}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: height * 0.2, minHeight: height * 0.1),
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(date, style: TextStyle(color: Color(0xFF60BBFE))),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: reports.length,
                        itemBuilder: ((context, index) {
                          String extension = reports[index].url.split('.').last;
                          bool isImage = extension.contains('jp');

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            Scaffold(
                                          appBar: AppBar(
                                              title:
                                                  Text(reports[index].title)),
                                          body: isImage
                                              ? PhotoView(
                                                  imageProvider: NetworkImage(
                                                      reports[index].url),
                                                )
                                              : SfPdfViewer.network(
                                                  reports[index].url),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    reports[index].title,
                                    style: TextStyle(color: Colors.black54),
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    await Get.find<AllHR>()
                                        .deleteHR(id: reports[index].id);
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          );
                        }))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Reports {
  final String title, url;
  final id;
  Reports({required this.title, required this.url, required this.id});
}

class FilteredReports {
  final date;
  List reports;
  FilteredReports({required this.date, required this.reports});
}

class AllHR extends GetxController {
  var allHr = <HR>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllHR();
  }

  getAllHR() async {
    var allHRs = await getHR();
    List r = []; //reports list
    if (allHRs[0] != null) {
      List<FilteredReports> allDates = [];

      var tempDate = allHRs[0]['date'];

      // allDates.add(FilteredReports(date: tempDate, reports: []));
      var i = 0;
      for (i = 0; i < allHRs.length; i++) {
        if (allHRs[i]['date'] != tempDate) {
          tempDate = allHRs[i]['date'];
          allDates.add(FilteredReports(date: tempDate, reports: r));
          r.clear();
          r.add(allHRs[i]);
        } else {
          r.add(allHRs[i]);
        }
      }

      allDates.add(FilteredReports(date: tempDate, reports: r));
      print(allDates[0].reports);
      allHr.value = allDates.map((e) {
        return HR(date: e.date, reports: listOfReports(e.reports));
      }).toList();
    } else {
      allHr.value = [];
    }
  }

  addHr(
      {required String title,
      required String url,
      required String date}) async {
    List<Reports> r = [];
    var response = await addHR(title: title, url: url, date: date);

    var specificHrListIndex =
        allHr.indexWhere((element) => element.date == date);
    if (specificHrListIndex == -1) {
      print("response: $response");
      r.add(Reports(title: title, url: url, id: response['id']));
      allHr.add(HR(date: date, reports: r));
      allHr.sort(((a, b) {
        bool isTrue = DateTime.parse(a.date).isBefore(DateTime.parse(b.date));
        if (isTrue) {
          return 1;
        } else {
          return -1;
        }
      }));
      return;
    }
    r = allHr[specificHrListIndex].reports;
    r.add(Reports(title: title, url: url, id: response['id']));
    allHr[specificHrListIndex] = HR(
      date: date,
      reports: r,
    );
  }

  deleteHR({required final id}) async {
    final response = await delHR(id: id);
    if (response == "Successfull") {
      var index = allHr.indexWhere((element) {
        var reports = element.reports;
        var i = 0;
        for (i = 0; i < reports.length; i++) {
          if (reports[i].id == id) {
            return true;
          }
        }
        return false;
      });
      if (allHr[index].reports.length == 1) {
        allHr.removeAt(index);
      } else {
        var specificHR = allHr[index].reports;
        specificHR.removeWhere((element) => element.id == id);
        allHr[index].reports = specificHR;
      }
      update();
    }
  }
}

List<Reports> listOfReports(List reports) {
  List<Reports> r = reports.map((e) {
    return Reports(title: e['title'], url: e['url'], id: e['_id']);
  }).toList();
  return r;
}
