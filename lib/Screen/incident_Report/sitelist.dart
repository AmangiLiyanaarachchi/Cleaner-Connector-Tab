// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// class DropDownList extends StatefulWidget {
//   const DropDownList({super.key});

//   @override
//   State<DropDownList> createState() => _DropDownListState();
// }

// class _DropDownListState extends State<DropDownList> {
//   var jsonList;

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   void getData() async {
//     try {
//       var dio = Dio();
//       var authToken =
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRlMDY2ODY2LTdmMGQtMTFlZS04MWM4LTBhNjE2NDI2YTJiNyIsImVtYWlsIjoidGVzdGVtYWlsQGdtYWlsLmNvbSIsInJvbGUiOiJzdXBlciBhZG1pbiIsImlhdCI6MTcwMTk2NTg0NywiZXhwIjoxNzA0NTU3ODQ3fQ.wItuUUJZYb5bdMsmfRqIdEORVM3e9VWJpQNWSnUIEKk';
//       dio.options.headers['Authorization'] = 'Bearer $authToken';
//       var response = await Dio().get(
//           'http://ec2-3-144-155-224.us-east-2.compute.amazonaws.com:8000/site/getall-sites');
//       if (response.statusCode == 200) {
//         setState(() {
//           jsonList = response.data["sites"] as List;
//         });
//       } else {
//         print(response.statusCode);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(6),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 7)
//             ]),
//         height: 50,
//         child: jsonList == null
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//                 itemCount: jsonList!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return DropdownMenuItem(
//                     value: jsonList![index]['site_id'],
//                     child: Text(jsonList![index]['site_name']),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
