// import 'package:cleanconnectortab/Screen/incident_report.dart';
// import 'package:cleanconnectortab/constants/style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:wc_form_validators/wc_form_validators.dart';

// class IncidentForm extends StatefulWidget {
//   const IncidentForm({super.key});

//   @override
//   State<IncidentForm> createState() => _IncidentFormState();
// }

// class _IncidentFormState extends State<IncidentForm> {
//   TextEditingController emailEditingController = new TextEditingController();
//   TextEditingController dateTimeEditingController = new TextEditingController();
//   TextEditingController incidenttypeEditingController =
//       new TextEditingController();
//   TextEditingController reportedbyEditingController =
//       new TextEditingController();
//   TextEditingController descriptionEditingController =
//       new TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   String email = '';
//   String password = '';
//   bool _isObscure = true;
//   bool isLoading = false;
//   bool typing = true;

//   @override
//   Widget build(BuildContext context) {
//     final Size = MediaQuery.of(context).size;
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 20),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const IncedentReport(),
//                   ));
//             },
//             child: const CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.black,
//               child: CircleAvatar(
//                 radius: 15,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.arrow_back_sharp,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         title: const Text(
//           'CREATE INCIDENT',
//           style: TextStyle(
//               fontFamily: "Open Sans",
//               fontSize: 20,
//               color: Colors.black,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8.0), // Add rounded corners
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 offset: Offset(2, 2),
//                 blurRadius: 2,
//               )
//             ],
//           ),
//           child: Padding(
//               padding: EdgeInsets.all(50),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Form(
//                       key: _formKey,
//                       autovalidateMode: AutovalidateMode.disabled,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                                 EdgeInsets.symmetric(horizontal: width * 0.1),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.person,
//                                   color: kiconColor,
//                                 ),
//                                 const SizedBox(
//                                   width: 30,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: width * 0.60,
//                                   decoration: BoxDecoration(
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           offset: Offset(2, 2),
//                                           blurRadius: 2,
//                                         )
//                                       ],
//                                       color: const Color.fromRGBO(
//                                           241, 239, 239, 0.298),
//                                       border: Border.all(
//                                           width: 0, color: Colors.white),
//                                       borderRadius: BorderRadius.circular(11)),
//                                   // width: width,
//                                   child: TextFormField(
//                                     controller: emailEditingController,
//                                     enabled: true,
//                                     decoration: InputDecoration(
//                                       fillColor: Colors.white,
//                                       filled: true,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                         ),
//                                         // borderSide: BorderSide.none
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.blue,
//                                         ),
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       isDense: true,
//                                       contentPadding: const EdgeInsets.fromLTRB(
//                                           15, 30, 15, 0),
//                                       hintText: "Full Name",
//                                       hintStyle: const TextStyle(
//                                           color: Colors.black54, fontSize: 18),
//                                     ),
//                                     style: const TextStyle(color: Colors.black),
//                                     validator: Validators.compose([
//                                       Validators.required(
//                                           'Site Name is Required'),
//                                     ]),
//                                     onChanged: (String? text) {
//                                       email = text!;
//                                       // print(email);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsets.symmetric(horizontal: width * 0.1),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.calendar_month,
//                                   color: kiconColor,
//                                 ),
//                                 const SizedBox(
//                                   width: 30,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: width * 0.60,
//                                   decoration: BoxDecoration(
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           offset: Offset(2, 2),
//                                           blurRadius: 2,
//                                         ),
//                                       ],
//                                       color: const Color.fromRGBO(
//                                           241, 239, 239, 0.298),
//                                       border: Border.all(
//                                           width: 0, color: Colors.white),
//                                       borderRadius: BorderRadius.circular(11)),
//                                   // width: width * 0.,
//                                   child: TextFormField(
//                                     controller: dateTimeEditingController,
//                                     enabled: true,
//                                     decoration: InputDecoration(
//                                       fillColor: Colors.white,
//                                       filled: true,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       isDense: true,
//                                       contentPadding: const EdgeInsets.fromLTRB(
//                                           15, 30, 15, 0),
//                                       hintText: "Date and Time",
//                                       hintStyle: const TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     style: const TextStyle(color: Colors.black),
//                                     onTap: () {
//                                       // Implement a date and time picker to set the value in the field
//                                       showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: DateTime(2000),
//                                         lastDate: DateTime(2101),
//                                       ).then((selectedDate) {
//                                         if (selectedDate != null) {
//                                           showTimePicker(
//                                             context: context,
//                                             initialTime: TimeOfDay.now(),
//                                           ).then((selectedTime) {
//                                             if (selectedTime != null) {
//                                               // Combine the selected date and time into a single DateTime object
//                                               DateTime selectedDateTime =
//                                                   DateTime(
//                                                 selectedDate.year,
//                                                 selectedDate.month,
//                                                 selectedDate.day,
//                                                 selectedTime.hour,
//                                                 selectedTime.minute,
//                                               );
//                                               dateTimeEditingController.text =
//                                                   selectedDateTime
//                                                       .toString(); // Set the value in the field
//                                             }
//                                           });
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsets.symmetric(horizontal: width * 0.1),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.person_3,
//                                   color: kiconColor,
//                                 ),
//                                 const SizedBox(
//                                   width: 30,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: width * 0.60,
//                                   decoration: BoxDecoration(
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           offset: Offset(2, 2),
//                                           blurRadius: 2,
//                                         )
//                                       ],
//                                       color: const Color.fromRGBO(
//                                           241, 239, 239, 0.298),
//                                       border: Border.all(
//                                           width: 0, color: Colors.white),
//                                       borderRadius: BorderRadius.circular(11)),
//                                   // width: width,
//                                   child: TextFormField(
//                                     controller: incidenttypeEditingController,
//                                     enabled: true,
//                                     decoration: InputDecoration(
//                                       fillColor: Colors.white,
//                                       filled: true,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                         ),
//                                         // borderSide: BorderSide.none
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.blue,
//                                         ),
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       isDense: true,
//                                       contentPadding: const EdgeInsets.fromLTRB(
//                                           15, 30, 15, 0),
//                                       hintText: "Incident Type",
//                                       hintStyle: const TextStyle(
//                                           color: Colors.black54, fontSize: 18),
//                                     ),
//                                     style: const TextStyle(color: Colors.black),
//                                     validator: Validators.compose([
//                                       Validators.required(
//                                           'Site Name is Required'),
//                                     ]),
//                                     onChanged: (String? text) {
//                                       email = text!;
//                                       // print(email);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsets.symmetric(horizontal: width * 0.1),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.person_add,
//                                   color: kiconColor,
//                                 ),
//                                 const SizedBox(
//                                   width: 30,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: width * 0.60,
//                                   decoration: BoxDecoration(
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           offset: Offset(2, 2),
//                                           blurRadius: 2,
//                                         )
//                                       ],
//                                       color: const Color.fromRGBO(
//                                           241, 239, 239, 0.298),
//                                       border: Border.all(
//                                           width: 0, color: Colors.white),
//                                       borderRadius: BorderRadius.circular(11)),
//                                   // width: width,
//                                   child: TextFormField(
//                                     controller: reportedbyEditingController,
//                                     enabled: true,
//                                     decoration: InputDecoration(
//                                       fillColor: Colors.white,
//                                       filled: true,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                         ),
//                                         // borderSide: BorderSide.none
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.blue,
//                                         ),
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       isDense: true,
//                                       contentPadding: const EdgeInsets.fromLTRB(
//                                           15, 30, 15, 0),
//                                       hintText: "Reported By",
//                                       hintStyle: const TextStyle(
//                                           color: Colors.black54, fontSize: 18),
//                                     ),
//                                     style: const TextStyle(color: Colors.black),
//                                     validator: Validators.compose([
//                                       Validators.required(
//                                           'Site Name is Required'),
//                                     ]),
//                                     onChanged: (String? text) {
//                                       email = text!;
//                                       // print(email);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsets.symmetric(horizontal: width * 0.1),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.description,
//                                   color: kiconColor,
//                                 ),
//                                 const SizedBox(
//                                   width: 30,
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: width * 0.60,
//                                   decoration: BoxDecoration(
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           offset: Offset(2, 2),
//                                           blurRadius: 2,
//                                         )
//                                       ],
//                                       color: const Color.fromRGBO(
//                                           241, 239, 239, 0.298),
//                                       border: Border.all(
//                                           width: 0, color: Colors.white),
//                                       borderRadius: BorderRadius.circular(11)),
//                                   // width: width,
//                                   child: TextFormField(
//                                     controller: descriptionEditingController,
//                                     enabled: true,
//                                     decoration: InputDecoration(
//                                       fillColor: Colors.white,
//                                       filled: true,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                         ),
//                                         // borderSide: BorderSide.none
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.blue,
//                                         ),
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                         borderSide:
//                                             const BorderSide(color: Colors.red),
//                                       ),
//                                       isDense: true,
//                                       contentPadding: const EdgeInsets.fromLTRB(
//                                           15, 30, 15, 0),
//                                       hintText: "Description",
//                                       hintStyle: const TextStyle(
//                                           color: Colors.black54, fontSize: 18),
//                                     ),
//                                     style: const TextStyle(color: Colors.black),
//                                     validator: Validators.compose([
//                                       Validators.required(
//                                           'Site Name is Required'),
//                                     ]),
//                                     onChanged: (String? text) {
//                                       email = text!;
//                                       // print(email);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 60,
//                           ),
//                           Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.play_circle,
//                                   color: kiconColor,
//                                 ),
//                                 isLoading
//                                     ? const Padding(
//                                         padding: EdgeInsets.only(left: 20.0),
//                                         child: SpinKitDualRing(
//                                           color: kiconColor,
//                                           size: 30,
//                                         ),
//                                       )
//                                     : TextButton(
//                                         child: const Text(
//                                           "SUBMIT INCIDENT",
//                                           style: TextStyle(
//                                               color: kiconColor, fontSize: 25),
//                                         ),
//                                         onPressed: () async {},
//                                       ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//       ),
//     );
//   }
// }
