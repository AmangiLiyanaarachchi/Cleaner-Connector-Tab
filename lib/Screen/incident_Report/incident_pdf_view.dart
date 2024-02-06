import 'package:cleanconnectortab/Screen/incident_Report/incident_report.dart';
import 'package:cleanconnectortab/constants/app_colors.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:flutter/material.dart';

class IncidentRepordPdfView extends StatefulWidget {
  const IncidentRepordPdfView({super.key});

  @override
  State<IncidentRepordPdfView> createState() => _IncidentRepordPdfViewState();
}

class _IncidentRepordPdfViewState extends State<IncidentRepordPdfView> {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IncidentReport()));
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
            'INCIDENT REPORT PDF VIEW',
            style: kTitle,
          ),
        ),
        // body: SfPdfViewer.asset(),
      ),
    );
  }
}
