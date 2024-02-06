// import 'dart:async';

// import 'package:cleanconnectortab/constants/style.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

// class PDFViewerIncidentReport extends StatefulWidget {
//   final String pdfAssetPath;

//   const PDFViewerIncidentReport({super.key, required this.pdfAssetPath});

//   @override
//   State<PDFViewerIncidentReport> createState() =>
//       _PDFViewerIncidentReportState();
// }

// class _PDFViewerIncidentReportState extends State<PDFViewerIncidentReport> {
//   final Completer<PDFViewController> _pdfViewController =
//       Completer<PDFViewController>();
//   final StreamController<String> _pageCountController =
//       StreamController<String>();

//   void callapiGet() async {
//     var dio = Dio();
//     var response = await dio.get(
//         'http://ec2-18-223-3-5.us-east-2.compute.amazonaws.com:8000/incident/completeList');
//     print(response.statusCode);
//     print(response.data.toString());
//   }

//   bool _checked = false;
//   bool _enabled = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         actions: <Widget>[
//           StreamBuilder<String>(
//               stream: _pageCountController.stream,
//               builder: (_, AsyncSnapshot<String> snapshot) {
//                 if (snapshot.hasData) {
//                   return Center(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         snapshot.data!,
//                         style: TextStyle(color: kiconColor),
//                       ),
//                     ),
//                   );
//                 }
//                 return const SizedBox();
//               }),
//         ],
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 20),
//           child: GestureDetector(
//             onTap: () {
//               callapiGet();
//             },
//             child: const CircleAvatar(
//               radius: 18,
//               backgroundColor: kiconColor,
//               child: CircleAvatar(
//                 radius: 17,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: kiconColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         title: const Text(
//           "INCIDENT REPORT PDF VIEW",
//           style: kTitle,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: PDF(
//               enableSwipe: true,
//               swipeHorizontal: false,
//               autoSpacing: false,
//               pageFling: false,
//               onPageChanged: (int? current, int? total) {
//                 _pageCountController.add('${current! + 1} - $total');
//               },
//               onViewCreated: (PDFViewController pdfViewController) async {
//                 _pdfViewController.complete(pdfViewController);
//                 final int currentPage =
//                     await pdfViewController.getCurrentPage() ?? 0;
//                 final int? pageCount = await pdfViewController.getPageCount();
//                 _pageCountController.add('${currentPage + 1} - $pageCount');
//               },
//             ).fromUrl(widget.pdfAssetPath),
//           ),
//         ],
//       ),
//     );
//   }
// }
