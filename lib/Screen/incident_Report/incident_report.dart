import 'package:cleanconnectortab/Dashboard.dart';
//import 'package:cleanconnectortab/Screen/incident_Report/incident_report_form.dart';
import 'package:cleanconnectortab/Screen/incident_Report/incident_report_list.dart';
import 'package:cleanconnectortab/Timer.dart';
import 'package:cleanconnectortab/constants/app_colors.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:cleanconnectortab/incident_report_form.dart';
// import 'package:cleanconnectortab/incident_report_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({super.key});

  @override
  State<IncidentReport> createState() => _IncidentReportState();
}

class _IncidentReportState extends State<IncidentReport> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.backColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                loginStatus == true?
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (_) => TimerScreen( ),
                    ),
                  )
                      :
                  Navigator.push( context, MaterialPageRoute(
                      builder: (context) => Dashboard()
                  ));
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: kiconColor,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.backColor,
                  child: Icon(
                    Icons.arrow_back,
                    color: kiconColor,
                  ),
                ),
              ),
            ),
          ),
          title: const Text(
            'INCIDENT REPORT',
            style: kTitle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(2, 2),
                  blurRadius: 2,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                 
                  const Expanded(child: CustomListView())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
