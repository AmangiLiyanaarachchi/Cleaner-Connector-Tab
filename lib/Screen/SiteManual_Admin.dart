// import 'package:cleanconnectortab/Screen/PDFViewer_site_manual.dart';
// import 'package:cleanconnectortab/Screen/PDFViewer_site_manual_admin.dart';
// import 'package:cleanconnectortab/Timer.dart';
// import 'package:cleanconnectortab/constants/pdsCard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:intl/intl.dart';
//
// import '../Dashboard.dart';
// import '../constants/style.dart';
// import 'PDFViewer.dart';
//
// class ReportCardData {
//   final String title;
//   final String imagePath;
//   final String pdfPath;
//   final List<NameWithDateTime> namesWithDateTime;
//
//   ReportCardData({
//     required this.title,
//     required this.imagePath,
//     required this.pdfPath,
//     required this.namesWithDateTime,
//   });
// }
//
// class NameWithDateTime {
//   final String name;
//   final DateTime dateTime;
//
//   NameWithDateTime({
//     required this.name,
//     required this.dateTime,
//   });
// }
//
// class NameListDialog extends StatelessWidget {
//
//   final List<NameWithDateTime> namesWithDateTime;
//
//   NameListDialog({required this.namesWithDateTime});
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       titlePadding: EdgeInsets.all(0),
//       title: Container(
//           height: 50,
//           width: 350,
//           color: kiconColor,
//           child: Center(child: Text('Acknowledged Employees',style: TextStyle(color: Colors.white,),))
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           children: namesWithDateTime.map((nameWithDateTime) {
//             final formattedDateTime = DateFormat('yyyy-MM-dd hh:mma').format(nameWithDateTime.dateTime);
//             return ListTile(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(nameWithDateTime.name, style: TextStyle(fontWeight: FontWeight.w400),),
//                   Text(formattedDateTime, style: TextStyle(color: Colors.grey),),
//
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: Text('Close',style: TextStyle(color: Color.fromARGB(255, 52, 137, 207),),),
//         ),
//       ],
//     );
//   }
// }
//
// class SiteManualAdmin extends StatefulWidget {
//   const SiteManualAdmin({super.key});
//
//   @override
//   State<SiteManualAdmin> createState() => _SiteManualAdminState();
// }
//
// class _SiteManualAdminState extends State<SiteManualAdmin> {
//   List<ReportCardData> assetsCards = [
//     ReportCardData(
//       title: 'Vaccum Cleaner Document',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         NameWithDateTime(name: 'Sarah', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Amy', dateTime: DateTime(2023, 9, 20, 10, 30),),
//       ],
//
//     ),
//     ReportCardData(
//       title: 'Vaccum Cleaner Document 2 & Cleaning Machine',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       ],
//     ),
//     ReportCardData(
//       title: 'Vaccum Cleaner Document',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       ],
//     ),
//     ReportCardData(
//       title: 'Vaccum Cleaner Document',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       ],
//     ),
//     ReportCardData(
//       title: 'Vaccum Cleaner Document',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       ],
//     ),
//     ReportCardData(
//       title: 'Vaccum Cleaner Document',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       ],
//     ),
//     ReportCardData(
//       title: 'Vaccum Cleaner Document',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       ],
//     ),
//     ReportCardData(
//       title: 'Vaccum Cleaner Document',
//       imagePath: 'assets/images/pdf.png',
//       pdfPath: 'assets/pdf/OR.pdf',
//       namesWithDateTime: [
//         NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//         NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//         NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//         NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       ],
//     ),
//
//
//   ];
//
//   List<String> names = ['John', 'Alice', 'Bob', 'Eve'];
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//             automaticallyImplyLeading: false,
//             centerTitle: true,
//             title: const Text(
//               "SITE MANUAL",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Color.fromARGB(255, 52, 137, 207)),
//             ),
//             backgroundColor: Colors.white,
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute<dynamic>(
//                       builder: (_) => TimerScreen( ),
//                     ),
//                   );
//                 },
//                 child: CircleAvatar(
//                   radius: 18,
//                   backgroundColor: kiconColor,
//                   child: CircleAvatar(
//                     radius: 17,
//                     backgroundColor: Colors.white,
//                     child: Icon(
//                       Icons.arrow_back,
//                       color: kiconColor,
//                     ),
//                   ),
//                 )
//             ),
//           ),),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius:
//               BorderRadius.circular(8.0), // Add rounded corners
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   offset: Offset(2, 2),
//                   blurRadius: 2,
//                 )
//               ],
//             ),
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: SizedBox(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: assetsCards.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute<dynamic>(
//                             builder: (_) => PDFViewerSiteManualAdmin(
//                               pdfAssetPath: assetsCards[index].pdfPath,
//                             ),
//                           ),
//                         );
//                       },
//                       child: PdfCardModel(
//                         widget: Stack(
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   width: 50,
//                                   height: 50,
//                                   margin: EdgeInsets.only(
//                                       left:
//                                           30), // Adjust the margin value here
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(15),
//                                       bottomLeft: Radius.circular(15),
//                                     ),
//                                     image: DecorationImage(
//                                       image: AssetImage(
//                                           assetsCards[index].imagePath),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//
//                                 SizedBox(
//                                     width:
//                                         20), // Add spacing between image and text
//
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         // color: Colors.amber,
//                                         child: Text(
//                                           assetsCards[index].title,
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 2,
//                                           textAlign: TextAlign.left,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 30.0),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return NameListDialog(namesWithDateTime: assetsCards[index].namesWithDateTime);
//                                         },
//                                       );
//                                     },
//                                     color: Color.fromARGB(255, 52, 137, 207),
//                                     icon: CircleAvatar(
//                                         backgroundColor: kiconColor,
//                                         child: const Icon(Icons.people, color: Colors.white,)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
