import 'package:cleanconnectortab/Screen/Help_Dashboard.dart';
import 'package:cleanconnectortab/Screen/view_help_data.dart';
import 'package:cleanconnectortab/communication_admin.dart';
import 'package:cleanconnectortab/communication_cleaner.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Dashboard.dart';
import '../Timer.dart';
import '../constants/const_api.dart';

class Message {
  final String senderName;
  final String text;
  final DateTime timestamp; // Add a timestamp field

  Message(this.senderName, this.text, this.timestamp);
}

class HelpScreen extends StatefulWidget {
  HelpScreen({
    required this.module,
  });

  final String module;

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> helpDocs = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Fetch data from the API
    fetchData(widget.module);
  }

  Future<void> fetchData(String module) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        "${BASE_API2}site/help",
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        if (data['status'] == true) {
          // Filter helpDocs based on the specified module
          List<Map<String, dynamic>> filteredHelpDocs =
              List<Map<String, dynamic>>.from(data['helpDocs'])
                  .where((helpData) => helpData['module'] == module)
                  .toList();

          setState(() {
            helpDocs = filteredHelpDocs;
          });
        }
      }
    } catch (error) {
      // Handle errors
      print("Error fetching data: $error");
    }
  }

  final String _userName = "Taniya";
  String _selectedOption = 'Select Cleaner';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "HELP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: kiconColor,
            ),
          ),
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpDash(),
                  ),
                );
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
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: helpDocs.map((helpData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpData(
                                title: helpData["heading"],
                                description: helpData["description"],
                                videoUrl: helpData["url"],
                                module: helpData["module"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10 * screenWidth / kWidth,
                            vertical: 10 * screenHeight / kHeight,
                          ),
                          decoration: BoxDecoration(
                            color: kcardBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: screenWidth,
                          height: screenHeight * 0.125,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  helpData["heading"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
