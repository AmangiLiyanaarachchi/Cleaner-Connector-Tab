import 'dart:async';
import 'package:cleanconnectortab/Screen/SiteManual.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:signature/signature.dart';

import 'Signature.dart';

// ignore: must_be_immutable
class PDFViewerSiteManualAdmin extends StatefulWidget {
  PDFViewerSiteManualAdmin({Key? key, required this.pdfAssetPath, required this.manualId})
      : super(key: key);
  final String pdfAssetPath;
  String manualId;

  @override
  _PDFViewerSiteManualAdminState createState() =>
      _PDFViewerSiteManualAdminState();
}

class _PDFViewerSiteManualAdminState extends State<PDFViewerSiteManualAdmin> {
  bool _isLastPage = false;
  bool _isAgreed = false;
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('PDF View',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kiconColor)),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: <Widget>[
              StreamBuilder<String>(
                  stream: _pageCountController.stream,
                  builder: (_, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            snapshot.data!,
                            style: TextStyle(color: kiconColor),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SiteManual()));
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
        body: Column(
          children: [
            Expanded(
              child: PDF(
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: false,
                // onPageChanged: (int? current, int? total) =>
                //     _pageCountController.add('${current! + 1} - $total'),

                onPageChanged: (int? current, int? total) {
                  final isLastPage = current == total! - 1;
                  _pageCountController.add('${current! + 1} - $total');

                  if (isLastPage) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Dashboard(), // Replace with your signature screen widget
                    //   ),
                    // );
                    setState(() {
                      _isLastPage =
                          true; // Use the assignment operator '=' to set the variable to true
                    });
                    // Show a button or a prompt to enter the digital signature
                    // You can use a state variable to control the visibility of this button or prompt
                  }
                },
                onViewCreated: (PDFViewController pdfViewController) async {
                  _pdfViewController.complete(pdfViewController);
                  final int currentPage =
                      await pdfViewController.getCurrentPage() ?? 0;
                  final int? pageCount = await pdfViewController.getPageCount();
                  _pageCountController.add('${currentPage + 1} - $pageCount');
                },
              ).fromUrl(widget.pdfAssetPath),
            ),
            Visibility(
              visible: _isLastPage,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: kiconColor,
                          value: _isAgreed,
                          onChanged: (value) {
                            setState(() {
                              _isAgreed = value ?? false;
                            });
                          },
                        ),
                        Text("I have read the document and agree to the policy")
                      ],
                    ),
                    if (_isLastPage && _isAgreed)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kiconColor,
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => Dashboard(),
                          //   ),
                          // );

                          // Create a SignatureController
                          final SignatureController _controller =
                              SignatureController(
                            penStrokeWidth: 5.0,
                            penColor: Colors.black,
                            exportBackgroundColor: Colors.white,
                          );

                          // Show the signature pad as a pop-up
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SignaturePad(
                                controller: _controller,
                                fromWhere: 'Site Manual',
                                manualId: widget.manualId,
                                document : widget.pdfAssetPath.toString(),
                              );
                            },
                          );
                        },
                        child: Text('Enter Digital Signature'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
