import 'package:cleanconnectortab/Dashboard.dart';
import 'package:cleanconnectortab/Screen/help_screen.dart';
import 'package:cleanconnectortab/Timer.dart';
import 'package:cleanconnectortab/communication_admin.dart';
import 'package:cleanconnectortab/communication_cleaner.dart';
import 'package:cleanconnectortab/constants/DashboardCard.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../constants/const_api.dart';

class Message {
  final String senderName;
  final String text;
  final DateTime timestamp; // Add a timestamp field

  Message(this.senderName, this.text, this.timestamp);
}

class HelpDash extends StatefulWidget {
  @override
  _HelpDashState createState() => _HelpDashState();
}

class _HelpDashState extends State<HelpDash> {
  List<CardModel> recipeCards = [
    CardModel(
      title: 'Communication',
      subtitle: 'Donat Twerski',
      rating: 'ASSETS',
      cookTime: '3m',
      customIcon: Icons.cached_rounded,
      status: 'OPEN',
      thumbnailUrl: 'assets/images/Communication_1.jpg',
    ),
    CardModel(
      title: 'Stock',
      subtitle: 'Donat Twerski',
      rating: 'ASSETS',
      cookTime: '3m',
      customIcon: Icons.real_estate_agent_outlined,
      status: 'OPEN',
      thumbnailUrl: 'assets/images/stock.png',
    ),
    CardModel(
      title: 'Incident Report',
      subtitle: 'Susan Bradley',
      rating: 'TROUBLESHOOT',
      cookTime: '3m',
      customIcon: Icons.assignment_outlined,
      status: 'IN PROGRESS',
      thumbnailUrl: 'assets/images/Incident_Report.png',
    ),
    CardModel(
      title: 'Site Manual',
      subtitle: 'Susan Bradley',
      rating: 'TROUBLESHOOT',
      cookTime: '3m',
      customIcon: Icons.settings,
      status: 'IN PROGRESS',
      thumbnailUrl: 'assets/images/SiteManual.jpg',
    ),
    CardModel(
      title: 'Site Information',
      subtitle: 'Donat Twerski',
      rating: 'ASSETS',
      cookTime: '3m',
      customIcon: Icons.info_outline,
      status: 'OPEN',
      thumbnailUrl: 'assets/images/siteinfo.png',
    ),
    CardModel(
      title: 'Tool Box Talk',
      subtitle: 'Donat Twerski',
      rating: 'ASSETS',
      cookTime: '3m',
      customIcon: Icons.layers,
      status: 'OPEN',
      thumbnailUrl: 'assets/images/Tool_Box.jpg',
    ),
    CardModel(
      title: 'Site Recomandation',
      subtitle: 'Donat Twerski',
      rating: 'ASSETS',
      cookTime: '3m',
      customIcon: Icons.recommend_outlined,
      status: 'OPEN',
      thumbnailUrl: 'assets/images/Recommendation_1.png',
    ),
    
  ];

  final String _userName = "Taniya";
  String _selectedOption = 'Select Cleaner';

  ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> helpDocs = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Fetch data from the API
    fetchData();
  }

  Future<void> fetchData() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        "${BASE_API2}site/help",
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        if (data['status'] == true) {
          setState(() {
            helpDocs = List<Map<String, dynamic>>.from(data['helpDocs']);
          });
        }
      }
    } catch (error) {
      // Handle errors
      print("Error fetching data: $error");
    }
  }

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
              )
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: screenHeight / 350,
            ),
            itemCount: recipeCards.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
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
                  child: GestureDetector(
                    onTap: () {
                      // Check the custom icon and navigate accordingly
                      if (recipeCards[index].title == 'Stock') {
                        // Navigate to CommunicationPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpScreen(
                              module: "Stock",
                            ),
                          ),
                        );
                      } else if (recipeCards[index].title == 'Tool Box Talk') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen(
                                      module: "Toolbox",
                                    )));
                      } else if (recipeCards[index].title == 'Communication') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen(
                                      module: "Communication",
                                    )));
                      } else if (recipeCards[index].title ==
                          'Site Information') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen(
                                      module: "Site Information",
                                    )));
                      } else if (recipeCards[index].title ==
                          'Site Recomandation') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen(
                                      module: "Site Recomandation",
                                    )));
                      } else if (recipeCards[index].title == 'Site Manual') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen(
                                      module: "Site Manual",
                                    )));
                      } else if (recipeCards[index].title ==
                          'Incident Report') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen(
                                      module: "Incident Report",
                                    )));
                      } // Add more cases for other custom icons as needed
                      // ...
                    },
                    child: DashboardCardModel(
                      title: index < recipeCards.length
                          ? recipeCards[index].title
                          : "",
                      subtitle: index < recipeCards.length
                          ? recipeCards[index].subtitle
                          : "",
                      rating: index < recipeCards.length
                          ? recipeCards[index].rating
                          : "",
                      cookTime: index < recipeCards.length
                          ? recipeCards[index].cookTime
                          : "",
                      customIcon: index < recipeCards.length
                          ? recipeCards[index].customIcon
                          : Icons.error,
                      status: index < recipeCards.length
                          ? recipeCards[index].status
                          : "",
                      thumbnailUrl: index < recipeCards.length
                          ? recipeCards[index].thumbnailUrl
                          : "",
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ));
  }
}

class CardModel {
  final String title;
  final String subtitle;
  final String rating;
  final String cookTime;
  final IconData customIcon;
  final String status;
  final String thumbnailUrl;

  CardModel({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.cookTime,
    required this.customIcon,
    required this.status,
    required this.thumbnailUrl,
  });
}
