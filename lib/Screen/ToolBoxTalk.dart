import 'package:cleanconnectortab/Timer.dart';
import 'package:cleanconnectortab/constants/pdsCard.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../Dashboard.dart';
import '../constants/const_api.dart';
import '../login.dart';
import 'PDFViewer.dart';
import 'PDFViewer_cleaner.dart';
import 'SiteManual.dart';

class ReportCardData {
  final String title;
  final String imagePath;
  final String pdfPath;
  // List<String> names;
  final List<NameWithDateTime> namesWithDateTime;

  ReportCardData({
    required this.title,
    required this.imagePath,
    required this.pdfPath,
    // required this.names,
    required this.namesWithDateTime,
  });
}

class NameWithDateTime {
  final String name;
  final DateTime dateTime;

  NameWithDateTime({
    required this.name,
    required this.dateTime,
  });
}
List<SignedUsers> ackList = [];
class NameListDialog extends StatelessWidget {
  final List<SignedUsers> ackList;

  NameListDialog({required this.ackList});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Container(
          height: 50,
          width: 350,
          color: kiconColor,
          child: Center(
              child: Text(
                'Acknowledged Employees',
                style: TextStyle(
                  color: Colors.white,
                ),
              ))),
      content: SingleChildScrollView(
        child: ackList.isEmpty ?
        Center(child: Text("There is no any acknowledge users."))
            : Column(
          children: ackList.map((e) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.fname,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    e.created_at,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: kiconColor,
            ),
          ),
        ),
      ],
    );
  }
}

bool isHistoryTB = false;

class ToolBoxtTalk extends StatefulWidget {
  const ToolBoxtTalk({super.key});

  @override
  State<ToolBoxtTalk> createState() => _ToolBoxtTalkState();
}

class _ToolBoxtTalkState extends State<ToolBoxtTalk> {
  List<PDFList> _pdfTBT= [];
  List<PDFList> _historyTBT= [];
  bool isLoading = false;
  bool isEmptyList = false;

  Future<List<PDFList>> getTBT() async {
    _pdfTBT = [];
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    try{
      final response = await Dio().get(
          "${BASE_API2}toolbox-talk/get",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200 && response.data['message'] == "ToolBoxTalk get Successfully") {
        _pdfTBT = [];
        for (Map i in data) {
         if (i['site_id'] == loginSiteData['id']) {
            PDFList pdfList = PDFList(
              id: i['id'] == null ? '' : i['id'],
              name: i['document_name'] == null ? '' : i['document_name'],
              url: i['document_link'],
              added_at: i['created_at'] == null ? '' : DateFormat("yyyy-MM-dd")
                  .format(DateTime.parse(i['created_at'])),
              site: i['site_id'] == null ? '' : i['site_id'],
            );
            if(i['site_id']  == loginSiteData['id']) {
              _pdfTBT.add(pdfList);
            }
          }
       }
        if(_pdfTBT.isEmpty){
          setState(() {
            isEmptyList = true;
          });
        }
        print("------------------");
        print(_pdfTBT.length);
      }
      return _pdfTBT;
    }on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print("Bad Error");
        print(e.response?.data["message"]);
        setState(() {
          isEmptyList= true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    return _pdfTBT;
  }

  Future<List<PDFList>> getHistoryTBT() async {
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    _historyTBT = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}toolbox-talk/get-cleaner-toolbox-history-talk/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200 && response.data['message'] == "Cleaner ToolBoxTalk get Successfully") {
        _historyTBT = [];
        for (Map i in data) {
          PDFList pdfList = PDFList(
            id: i['document_id'] == null ? '' : i['document_id'],
            name: i['document_name'] == null ? '' : i['document_name'],
            url: i['document_link'],
            added_at: i['created_at'] == null ? '' : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(i['created_at'])),
            site: i['site_name'] == null ? '' : i['site_name'],
          );
          _historyTBT.add(pdfList);
        }
        print("------------------");
        print(_historyTBT.length);
        if(_historyTBT.isEmpty){
          setState(() {
            isEmptyList= true;
          });
        }
      }
      return _historyTBT;
    }on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        print("Bad Error");
        print(e.response?.data["message"]);
        setState(() {
          isEmptyList= true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    return _historyTBT;
  }

  // Future<List<PDFList>> getHistoryTBT() async {
  //   _pdfTBT = [];
  //   print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
  //   try{
  //     final response = await Dio().get(
  //         "${BASE_API2}toolbox-talk/get-cleaner-toolbox-history-talk/${loginSiteData['id']}",
  //         options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
  //     var data = response.data['data'];
  //     print("DATA: $data");
  //     if (response.statusCode == 200 && response.data['message'] == "ToolBoxTalk get Successfully") {
  //       _pdfTBT = [];
  //       for (Map i in data) {
  //         if (i['site_id'] == loginSiteData['id']) {
  //           PDFList pdfList = PDFList(
  //             id: i['id'] == null ? '' : i['id'],
  //             name: i['document_name'] == null ? '' : i['document_name'],
  //             url: i['document_link'],
  //             added_at: i['created_at'] == null ? '' : DateFormat("yyyy-MM-dd")
  //                 .format(DateTime.parse(i['created_at'])),
  //             site: i['site_id'] == null ? '' : i['site_id'],
  //           );
  //           _pdfTBT.add(pdfList);
  //         }
  //       }
  //       if(data == []){
  //         setState(() {
  //           isEmptyList = true;
  //         });
  //       }
  //       print("------------------");
  //       print(_pdfTBT.length);
  //     }
  //     return _pdfTBT;
  //   }on DioException catch (e) {
  //     if (e.response?.statusCode == 404) {
  //       print("Bad Error");
  //       print(e.response?.data["message"]);
  //       setState(() {
  //         isEmptyList= true;
  //       });
  //     }
  //     print(e.toString());
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print(e);
  //   }
  //   return _pdfTBT;
  // }

  Future<List<SignedUsers>> getAcknowledgeUsers(String manualId) async {
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']} \n ${manualId}");
    ackList = [];
    try{
      
      final response = await Dio().get(
          "${BASE_API2}toolbox-talk/get-readers-with-doc-id/${manualId}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));

      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200) {
        print("Get ack list $data");
        ackList = [];
        for (Map i in data) {
          print("Get ack list");
          
          SignedUsers signedList = SignedUsers(
            fname: i['user_name'] == null ? '' : i['user_name'],
            created_at: i['created_at'] == null ? '' : DateFormat("yyyy-MM-dd") .format(DateTime.parse(i['created_at'])),
          );
          ackList.add(signedList);
          print("Get ack list 2");
          
        }
        print("Get ack list ------------------ ${ackList.length}");
        print(ackList.length);
      }
      return ackList;
    }on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        print("Bad Error");
        print(e.response?.data["message"]);
        setState(() {
          isEmptyList= true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    return ackList;
  }

  @override
  void initState() {
    setState(() {
      isHistoryTB = false;
    });
    print("Site Manual history: $isHistorySM");
  }

  List<ReportCardData> assetsCards = [
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
        NameWithDateTime(
            name: 'Sarah', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Amy',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document 2 & Cleaning Machine',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
  ];

  List<ReportCardData> historyTB = [
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
        NameWithDateTime(
            name: 'Sarah', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Amy',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document 2 & Cleaning Machine',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
    ReportCardData(
      title: 'Vaccum Cleaner Document',
      imagePath: 'assets/images/pdf.png',
      pdfPath: 'assets/pdf/OR.pdf',
      namesWithDateTime: [
        NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
        NameWithDateTime(
            name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
        NameWithDateTime(
          name: 'Bob',
          dateTime: DateTime(2023, 9, 20, 10, 30),
        ),
        NameWithDateTime(
          name: 'Eve',
          dateTime: DateTime(2023, 9, 19, 10, 30),
        ),
        NameWithDateTime(
          name: 'Emily Johnson',
          dateTime: DateTime(2023, 9, 10, 10, 30),
        ),
      ],
    ),
  ];

  List<String> names = ['John', 'Alice', 'Bob', 'Eve'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    loginStatus == true ? TimerScreen() : Dashboard()),
            (Route<dynamic> route) => false,
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: (isHistoryTB == true)
                  ? Text(
                      "TOOL BOX TALK - History",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: kiconColor),
                    )
                  : Text(
                      "TOOL BOX TALK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: kiconColor),
                    ),
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: GestureDetector(
                    onTap: () {
                      (isHistoryTB == true)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ToolBoxtTalk()))
                          : (loginStatus == true)
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimerScreen()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()));
                      setState(() {
                        isHistoryTB = false;
                      });
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: kiconColor,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_back,
                          color: kiconColor,
                        ),
                      ),
                    )),
              )),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0), // Add rounded corners
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    blurRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 20, bottom: 10, top: 10),
                    child: (isHistoryTB == true)
                        ? SizedBox()
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: kiconColor,),
                          onPressed: () {
                            setState(() {
                              isHistoryTB = true;
                            });
                          },
                          child: Text('History'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: FutureBuilder(
                        future:  isHistoryTB == true ? getHistoryTBT() : getTBT(),
                        builder: (context, AsyncSnapshot<List<PDFList>> snapshot) {
                          return (isEmptyList==true)?
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
                            child: Text("No pdf to preview"),
                          )
                              : (isLoading ==true)? const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: SpinKitDualRing(
                              color: kiconColor,
                              size: 30,
                            ),
                          ) : ListView.builder(
                              itemCount: (isHistoryTB == true)
                                  ? _historyTBT.length
                                  : _pdfTBT.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (_) => loginStatus == true
                                              ? PDFViewerFromAsset_cleaner(
                                            pdfAssetPath: _pdfTBT[index].url.toString(), manualId: _pdfTBT[index].id,
                                          )
                                              : PDFViewerFromAsset(
                                            pdfAssetPath: _pdfTBT[index].url, manualId: _pdfTBT[index].id,
                                          ),
                                        ));
                                  },
                                  child: PdfCardModel(
                                    widget: Stack(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              margin: EdgeInsets.only(
                                                  left:
                                                  30), // Adjust the margin value here
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  bottomLeft: Radius.circular(15),
                                                ),
                                                image: DecorationImage(
                                                  image: AssetImage('assets/images/pdf.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                20), // Add spacing between image and text
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    // color: Colors.amber,
                                                    child: Text(
                                                      isHistoryTB == true
                                                          ? _historyTBT[index].name
                                                          : _pdfTBT[index].name,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(
                                                    // color: Colors.amber,
                                                    child: Text(
                                                      isHistoryTB == true
                                                          ? _historyTBT[index].added_at
                                                          : _pdfTBT[index].added_at,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 30.0),
                                              child: IconButton(
                                                onPressed: () async{
                                                  await getAcknowledgeUsers(isHistoryTB == true ?  _historyTBT[index].id : _pdfTBT[index].id);
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return NameListDialog(
                                                          ackList: isHistoryTB ==
                                                              true
                                                              ? ackList
                                                              : ackList);
                                                    },
                                                  );
                                                },
                                                color: kiconColor,
                                                icon: CircleAvatar(
                                                    backgroundColor: kiconColor,
                                                    child: const Icon(
                                                      Icons.people,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          ;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignedUsers {
  String fname, created_at;

  SignedUsers(
      {required this.fname,
        required this.created_at
      });
}
