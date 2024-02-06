import 'package:cleanconnectortab/Screen/PDFViewer_site_manual.dart';
import 'package:cleanconnectortab/constants/pdsCard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../SiteInfo.dart';
import '../constants/const_api.dart';
import '../constants/style.dart';
import '../login.dart';

List<AuditList> _audit= [];

class Audit extends StatefulWidget {
  const Audit({super.key});

  @override
  State<Audit> createState() => _AuditState();
}

class _AuditState extends State<Audit> {
  bool isLoading = false;
  bool isEmptyList = false;

  Future<List<AuditList>> getAudit() async {
    print("Getting users.... ${loginSiteData['id']}  \n ${loginSiteData['accessToken']}");
    try{
      final response = await Dio().get(
          "${BASE_API2}audit/get-audit-by-site/${loginSiteData['id']}",
          options: Options(headers: {"Authorization": loginSiteData['accessToken']}));

      var data = response.data['data'];
      print("DATA: $data");
      if (response.statusCode == 200 && response.data['message'] == "get audits filtered by site Id successfully") {
        _audit = [];
        for (Map i in data) {
          AuditList auditList = AuditList(
            audit_id: i['audit_id'],
            document_name: i['document_name'] == null ? '' : i['document_name'],
            document: i['document'],
            created_at: i['created_at'] == null ? '' : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(i['created_at'])),
          );
          _audit.add(auditList);
        }
        print("------------------");
        print(_audit.length);
      }
      return _audit;
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
    return _audit;
  }

  @override
  void initState() {
    getAudit();
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
                const SiteInformation()),
                (Route<dynamic> route) => false,
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              "AUDIT" ,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: kiconColor),
            ),
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SiteInformation()));
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
                  isLoading?
                  SpinKitDualRing(color: Colors.black,)
                      : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: FutureBuilder(
                        future:  getAudit(),
                        builder: (context, AsyncSnapshot<List<AuditList>> snapshot) {
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
                              itemCount: _audit.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                          builder: (_) => PDFViewerSiteManual(
                                            pdfAssetPath: _audit[index].document,
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
                                                    child: Text(_audit[index].document_name,
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
                                                     _audit[index].created_at,
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

class AuditList {
  int audit_id;
  String document_name, document, created_at;

  AuditList(
      {required this.audit_id,
        required this.document_name,
        required this.document,
        required this.created_at
      });
}
