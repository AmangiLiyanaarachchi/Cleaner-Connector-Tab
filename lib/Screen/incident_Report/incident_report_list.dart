// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:cleanconnectortab/constants/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../constants/const_api.dart';
import 'PDFViewer_Incident.dart';

class PDFList {
  String id, name, url, added_at, site;

  PDFList(
      {required this.id,
        required this.name,
        required this.url,
        required this.added_at,
        required this.site
      });
}
class CustomListView extends StatefulWidget {
  const CustomListView({super.key});

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

  List<PDFList> _pdf= [];

class _CustomListViewState extends State<CustomListView> {
  var jsonList;


  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      print("Incident Details");
      var response = await Dio().get( '${BASE_API2}incident/completeList');
      print("Incident Details ${response.data}");
      if (response.statusCode == 200) {
        // var data = response.data['incidentList'];
        // _pdf = [];
        // for (Map i in data) {
        //   PDFList pdfList = PDFList(
        //     id: i['id'] == null ? '' : i['id'],
        //     name: i['f_name'] +" " + i['sur_name'],
        //     url: i['file'] == null ? '' :i['file'],
        //     // added_at: i['date_reported'] == null ? '' : DateFormat("yyyy-MM-dd")
        //         // .format(DateTime.parse(i['date_reported'])),
        //     site: i['site_address'] == null ? '' : i['site_address'],
        //   );
        //     if(i['site'] == loginSiteData['id']) {
        //       _pdf.add(pdfList);
        //     }
        // }
        // print("------------------ ${_pdf.length}");
        setState(() {
          jsonList = response.data["incidentList"] as List;
        });

        print("------------------ ${jsonList.length}");
      } else {
        print(response.statusCode);
      }
      print("Incident Details ${jsonList}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            onTap: () {
              // Navigator.push(
              //   context,
              //     MaterialPageRoute<dynamic>(
              //       builder: (_) => PDFViewerIncident(
              //         pdfAssetPath: jsonList[index].url,
              //       )),
              //     );
            },
            leading: const Image(image: AssetImage('assets/images/pdf.png')),
            title: Row(
              children: [
                Text(
                  jsonList[index]["f_name"],
                  style: klistTitle,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  jsonList[index]["sur_name"],
                  style: klistTitle,
                ),
              ],
            ),
            subtitle: Text(
              jsonList[index]["description"],
              style: klistTitle,
            ),
          ),
        );
      },
      itemCount: jsonList == null ? 0 : jsonList.length,
    ));
  }
}
