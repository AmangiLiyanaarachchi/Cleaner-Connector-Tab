import 'package:cleanconnectortab/Screen/PDFViewer_site_manual.dart';
import 'package:cleanconnectortab/constants/pdsCard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../Dashboard.dart';
import '../SiteInfo.dart';
import '../Timer.dart';
import '../constants/const_api.dart';
import '../constants/style.dart';
import '../login.dart';
import 'PDFViewer.dart';
import 'PDFViewer_site_manual_admin.dart';

class ReportCardData {
  final String title;
  final String imagePath;
  final String pdfPath;
  final List<NameWithDateTime> namesWithDateTime;

  ReportCardData({
    required this.title,
    required this.imagePath,
    required this.pdfPath,
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
List<PDFList> _pdf= [];
List<PDFList> _historyPdf= [];
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
                    e.fname +" "+e.lname,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    e.read_at,
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

bool isHistorySM = false;

class SiteManual extends StatefulWidget {
  const SiteManual({super.key});

  @override
  State<SiteManual> createState() => _SiteManualState();
}

class _SiteManualState extends State<SiteManual> {
  bool isLoading = false;
  bool isEmptyList = false;

  Future<List<PDFList>> getSiteManuals() async {
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    userList = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}site/site-manual/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['site_manuals'];
      print("DATA: $data");
      if (response.statusCode == 200 && response.data['message'] == "Site Manuals Retrieved Successfully") {
        _pdf = [];
        for (Map i in data) {
          PDFList pdfList = PDFList(
            id: i['id'] == null ? '' : i['id'],
            name: i['name'] == null ? '' : i['name'],
            url: i['url'],
            added_at: i['added_at'] == null ? '' : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(i['added_at'])),
            site: i['site'] == null ? '' : i['site'],
          );
          _pdf.add(pdfList);
        }
        print("------------------");
        print(_pdf.length);
      }
      return _pdf;
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
    return _pdf;
  }

  Future<List<PDFList>> getSiteManualHistory() async {
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    _historyPdf = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}site/site-manual/history/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['site_manuals'];
      print("DATA: $data");
      if (response.statusCode == 200 && response.data['message'] == "Site Manuals Retrieved Successfully") {
        _historyPdf = [];
        for (Map i in data) {
          PDFList pdfList = PDFList(
            id: i['id'] == null ? '' : i['id'],
            name: i['name'] == null ? '' : i['name'],
            url: i['url'],
            added_at: i['added_at'] == null ? '' : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(i['added_at'])),
            site: i['site'] == null ? '' : i['site'],
          );
          _historyPdf.add(pdfList);
        }
        print("------------------");
        print(_historyPdf.length);
      }
      return _historyPdf;
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
    return _historyPdf;
  }

  Future<List<SignedUsers>> getAcknowledgeUsers(String manualId) async {
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    print("manual ID: ${manualId}");
    ackList = [];
    try{
      final response = await Dio().get(
          "${BASE_API2}user/site-manual-refer/${manualId}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));
      var data = response.data['refered'];
      print("DATA: $data");
      if (response.statusCode == 200 && response.data['message'] == "Fetched Successfully") {
        ackList = [];
        for (Map i in data) {
          SignedUsers signedList = SignedUsers(
            fname: i['f_name'] == null ? '' : i['f_name'],
            lname: i['l_name'] == null ? '' : i['l_name'],
            read_at: i['read_at'] == null ? '' : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(i['read_at'])),
          );
          ackList.add(signedList);
        }
        print("------------------");
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

  List<ReportCardData> historyCards = [
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

  List<String> names = ['John', 'Alice', 'Bob', 'Eve'];

  @override
  void initState() {
    setState(() {
      isHistorySM = false;
    });
    getSiteManuals();
    getSiteManualHistory();
    print("Site Manual history: $isHistorySM");
  }

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
            title: Text(
              (isHistorySM == true) ? "SITE MANUAL - History" : "SITE MANUAL",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: kiconColor),
            ),
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    (isHistorySM == true)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SiteManual()))
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
                      isHistorySM = false;
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
            ),
          ),
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
                    child: (isHistorySM == true)
                        ? SizedBox()
                        : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: kiconColor,),
                        onPressed: () {
                          setState(() {
                            isHistorySM = true;
                          });
                        },
                        child: Text('History'),
                      ),
                    ],
                    ),
                  ),
                  isLoading?
                      SpinKitDualRing(color: Colors.black,)
                  : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: FutureBuilder(
                        future:  isHistorySM == true ? getSiteManualHistory() : getSiteManuals(),
                        builder: (context, AsyncSnapshot<List<PDFList>> snapshot) {
                          return  (isEmptyList==true)?
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
                            child: Text("No pdf to preview"),
                          )
                              : (isLoading==true)? const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: SpinKitDualRing(
                              color: kiconColor,
                              size: 30,
                            ),
                          )
                          : ListView.builder(
                              itemCount: (isHistorySM == true)
                                  ? _historyPdf.length
                                  : _pdf.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                          builder: (_) => loginStatus == true
                                              ? PDFViewerSiteManualAdmin(
                                            pdfAssetPath: (isHistorySM ==
                                                true)
                                                ? _historyPdf[index].url
                                                : _pdf[index].url, manualId: _pdf[index].id,
                                          )
                                              : PDFViewerSiteManual(
                                            pdfAssetPath: (isHistorySM ==
                                                true)
                                                ? _historyPdf[index].url
                                                : _pdf[index].url,
                                          )),
                                    );
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
                                                      isHistorySM == true
                                                          ? _historyPdf[index].name
                                                          : _pdf[index].name,
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
                                                      isHistorySM == true
                                                          ? _historyPdf[index].added_at
                                                          : _pdf[index].added_at,
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
                                                  await getAcknowledgeUsers(isHistorySM == true
                                                      ?  _historyPdf[index].id : _pdf[index].id);
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return NameListDialog(
                                                          ackList: isHistorySM ==
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
                              });
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

class SignedUsers {
  String fname, lname, read_at;

  SignedUsers(
      {required this.fname,
        required this.lname,
        required this.read_at
      });
}