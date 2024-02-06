// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:intl/intl.dart';
//
// import '../Dashboard.dart';
// import '../Timer.dart';
// import '../constants/style.dart';
// import 'PDFViewer_cleaner.dart';
//
// class ReportCardData {
//   final String title;
//   final String imagePath;
//   final String pdfPath;
//   // List<String> names;
//   final List<NameWithDateTime> namesWithDateTime;
//
//   ReportCardData({
//     required this.title,
//     required this.imagePath,
//     required this.pdfPath,
//     // required this.names,
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
//
//       title: Container(
//         height: 50,
//         width: 350,
//         color: kiconColor,
//         child: Center(child: Text('Acknowledged Employees',style: TextStyle(color: Colors.white,),))
//       ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: namesWithDateTime.map((nameWithDateTime) {
//                 final formattedDateTime = DateFormat('yyyy-MM-dd hh:mma').format(nameWithDateTime.dateTime);
//                 return ListTile(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(nameWithDateTime.name, style: TextStyle(fontWeight: FontWeight.w400),),
//                       Text(formattedDateTime, style: TextStyle(color: Colors.grey),),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Close',style: TextStyle(color: Color.fromARGB(255, 52, 137, 207),),),
//             ),
//           ],
//         );
//   }
// }
//
// class ToolBoxTalk_cleaner extends StatefulWidget {
//   const ToolBoxTalk_cleaner({super.key});
//
//   @override
//   State<ToolBoxTalk_cleaner> createState() => _ToolBoxTalk_cleanerState();
// }
//
// class _ToolBoxTalk_cleanerState extends State<ToolBoxTalk_cleaner> {
// bool isHistoryTBC = false;
//   List<ReportCardData> assetsCards = [
//     ReportCardData(
//         title: 'Vaccum Cleaner Document',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//           NameWithDateTime(name: 'Sarah', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Amy', dateTime: DateTime(2023, 9, 20, 10, 30),),
//         ],
//
//         ),
//     ReportCardData(
//         title: 'Vaccum Cleaner Document 2 & Cleaning Machine',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         ],
//         ),
//     ReportCardData(
//         title: 'Vaccum Cleaner Document',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         ],
//         ),
//       ReportCardData(
//         title: 'Vaccum Cleaner Document',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         ],
//         ),
//       ReportCardData(
//         title: 'Vaccum Cleaner Document',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         ],
//         ),
//       ReportCardData(
//         title: 'Vaccum Cleaner Document',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         ],
//       ),
//       ReportCardData(
//         title: 'Vaccum Cleaner Document',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         ],
//       ),
//       ReportCardData(
//         title: 'Vaccum Cleaner Document',
//         imagePath: 'assets/images/pdf.png',
//         pdfPath: 'assets/pdf/OR.pdf',
//         namesWithDateTime: [
//           NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//           NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//           NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//           NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//           NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//         ],
//       ),
//
//
//   ];
//
//   List<ReportCardData> historyTB = [
//   ReportCardData(
//     title: 'Vaccum Cleaner Document',
//     imagePath: 'assets/images/pdf.png',
//     pdfPath: 'assets/pdf/OR.pdf',
//     namesWithDateTime: [
//       NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//       NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//       NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//       NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//       NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//       NameWithDateTime(name: 'Sarah', dateTime: DateTime(2023, 9, 30, 10, 30)),
//       NameWithDateTime(name: 'Amy', dateTime: DateTime(2023, 9, 20, 10, 30),),
//     ],
//
//   ),
//   ReportCardData(
//     title: 'Vaccum Cleaner Document 2 & Cleaning Machine',
//     imagePath: 'assets/images/pdf.png',
//     pdfPath: 'assets/pdf/OR.pdf',
//     namesWithDateTime: [
//       NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//       NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//       NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//       NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//       NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//     ],
//   ),
//   ReportCardData(
//     title: 'Vaccum Cleaner Document',
//     imagePath: 'assets/images/pdf.png',
//     pdfPath: 'assets/pdf/OR.pdf',
//     namesWithDateTime: [
//       NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//       NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//       NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//       NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//       NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//     ],
//   ),
//   ReportCardData(
//     title: 'Vaccum Cleaner Document',
//     imagePath: 'assets/images/pdf.png',
//     pdfPath: 'assets/pdf/OR.pdf',
//     namesWithDateTime: [
//       NameWithDateTime(name: 'John Smith', dateTime: DateTime.now()),
//       NameWithDateTime(name: 'Alice', dateTime: DateTime(2023, 9, 30, 10, 30)),
//       NameWithDateTime(name: 'Bob', dateTime: DateTime(2023, 9, 20, 10, 30),),
//       NameWithDateTime(name: 'Eve', dateTime: DateTime(2023, 9, 19, 10, 30),),
//       NameWithDateTime(name: 'Emily Johnson', dateTime: DateTime(2023, 9, 10, 10, 30),),
//     ],
//   ),
//
//
// ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           title: const Text(
//             "TOOL BOX TALK",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Color.fromARGB(255, 52, 137, 207)
//             ),
//           ),
//           backgroundColor: Colors.white,
//
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 20),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute<dynamic>(
//                     builder: (_) => TimerScreen( ),
//                   ),
//                 );
//               },
//               child:  CircleAvatar(
//                 radius: 18,
//                 backgroundColor: kiconColor,
//                 child: CircleAvatar(
//                   radius: 17,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: kiconColor,
//                   ),
//                 ),
//               )
//             ),
//           )
//
//         ),
//
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
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //       builder: (context) => const IncidentForm(),
//                       //     ));
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: kiconColor,
//                           ),
//                           child: const Icon(
//                             Icons.history,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         const Text('History',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(255, 52, 137, 207))),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: SizedBox(
//                      // width: MediaQuery.of(context).size.width*0.5,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: assetsCards.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                               context,
//                               MaterialPageRoute<dynamic>(
//                                 builder: (_) => PDFViewerFromAsset_cleaner(
//                                   pdfAssetPath: assetsCards[index].pdfPath,
//                                 ),
//                               ),
//                               );
//                             },
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 color: Color.fromARGB(44, 185, 198, 209),
//                                 borderRadius: BorderRadius.circular(15),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.white.withOpacity(0.6),
//                                     offset: Offset(
//                                       0.0,
//                                       10.0,
//                                     ),
//                                     blurRadius: 3.0,
//                                     spreadRadius: -6.0,
//                                   ),
//                                 ],
//                               ),
//                               child: Stack(
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         width: 60,
//                                         height: 60,
//                                         margin:EdgeInsets.only(left: 30), // Adjust the margin value here
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(15),
//                                             bottomLeft: Radius.circular(15),
//                                           ),
//                                           image: DecorationImage(
//                                             image: AssetImage(assetsCards[index].imagePath),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//
//                                       SizedBox(width: 20), // Add spacing between image and text
//
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               // color: Colors.amber,
//                                               child: Text(
//                                                 assetsCards[index].title,
//                                                 style: TextStyle(
//                                                   fontSize: 16,
//                                                 ),
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 2,
//                                                 textAlign: TextAlign.left,
//                                               ),
//                                             ),
//
//                                           ],
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 30.0),
//                                         child: IconButton(
//                                           onPressed: () {
//                                             showDialog(
//                                               context: context,
//                                               builder: (BuildContext context) {
//                                                 return NameListDialog(namesWithDateTime: assetsCards[index].namesWithDateTime);
//                                               },
//                                             );
//                                           },
//                                           color: Color.fromARGB(255, 52, 137, 207),
//                                           icon: CircleAvatar(
//                                               backgroundColor: kiconColor,
//                                               child: const Icon(Icons.people, color: Colors.white,)),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//         ),
//       ),
//     );
//   }
// }