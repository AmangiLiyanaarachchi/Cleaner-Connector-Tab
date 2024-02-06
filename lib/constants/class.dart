// // import 'package:cleanconnectortab/Screen/report.dart';
// // import 'package:cleanconnectortab/constants/pdsCard.dart';
// // import 'package:cleanconnectortab/constants/style.dart';
// // import 'package:flutter/material.dart';

// // ////////// List View
// // class CustomListView extends StatefulWidget {
// //   const CustomListView({
// //     super.key,
// //   });

// //   @override
// //   State<CustomListView> createState() => _CustomListViewState();
// // }

// // class _CustomListViewState extends State<CustomListView> {
// //   var items =
// //       List<String>.generate(10, (index) => 'Incident Report ${index + 1}');

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: items.length,
// //       itemBuilder: (context, index) {
// //         return IncidentTile(
// //           title: 'Incident Report ${index + 1}',
// //           subtitle: 'Mark Anthony',
// //           leading: const Image(image: AssetImage('assets/images/pdf.png')),
// //         );
// //       },
// //     );
// //   }
// // }

// // ////////// List Tile
// // class IncidentTile extends StatelessWidget {
// //   final String title;
// //   final String subtitle;
// //   final Widget leading;

// //   const IncidentTile(
// //       {super.key,
// //       required this.title,
// //       required this.subtitle,
// //       required this.leading});


// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //                 builder: (context) => const PDFViewerIncidentReport(
// //                       pdfAssetPath: '',
// //                     )));
// //       },
// //         onTap: () {
// //           // Navigator.push(context,
// //           //     MaterialPageRoute(builder: (context) => const ReportDetails()));
// //         },
// //       child: PdfCardModel(
// //         widget: Stack(
// //           children: [
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   margin:
// //                       EdgeInsets.only(left: 30), // Adjust the margin value here
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.only(
// //                       topLeft: Radius.circular(15),
// //                       bottomLeft: Radius.circular(15),
// //                     ),
// //                   ),
// //                   child: leading,
// //                 ),
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const PDFViewerIncidentReport(
//                       pdfAssetPath: '',
//                     )));
//       },
//       child: PdfCardModel(
//         widget: Stack(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   margin:
//                       EdgeInsets.only(left: 30), // Adjust the margin value here
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15),
//                       bottomLeft: Radius.circular(15),
//                     ),
//                   ),
//                   child: leading,
//                 ),

// //                 SizedBox(width: 20), // Add spacing between image and text

// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Container(
// //                         // color: Colors.amber,
// //                         child: Text(
// //                           title,
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                           ),
// //                           overflow: TextOverflow.ellipsis,
// //                           maxLines: 2,
// //                           textAlign: TextAlign.left,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),

// //         // ListTile(
// //         //   leading: leading,
// //         //   title: Text(
// //         //     title,
// //         //
// //         //     style: const TextStyle(
// //         //         fontFamily: "Open Sans",
// //         //         fontSize: 18,
// //         //         fontWeight: FontWeight.bold),
// //         //   ),
// //         //   subtitle: Text(
// //         //     subtitle,
// //         //     style: const TextStyle(
// //         //         fontFamily: "Open Sans",
// //         //         fontSize: 15,
// //         //         fontWeight: FontWeight.w500),
// //         //
// //         //   ),
// //         //   onTap: () {
// //         //     Navigator.push(context,
// //         //         MaterialPageRoute(builder: (context) => const ReportDetails()));
// //         //   },
// //         // ),
// //       ),
// //     );
// //   }
// // }
