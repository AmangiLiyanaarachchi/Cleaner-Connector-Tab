// import 'dart:async';

// import 'package:cleanconnectortab/AdminLogin.dart';
// import 'package:cleanconnectortab/CleanerLogin.dart';
// import 'package:cleanconnectortab/CleanerLogin.dart';
// import 'package:cleanconnectortab/AdminLogin.dart';
import 'package:cleanconnectortab/CleanerLogin.dart';
import 'package:cleanconnectortab/Communication.dart';
import 'package:cleanconnectortab/Screen/Help_Dashboard.dart';
// import 'package:cleanconnectortab/Screen/SiteManual.dart';
// import 'package:cleanconnectortab/Screen/SiteManual_Admin.dart';
import 'package:cleanconnectortab/Screen/ToolBoxTalk.dart';
import 'package:cleanconnectortab/Screen/help_screen.dart';
import 'package:cleanconnectortab/Screen/incident_Report/incident_report.dart';
// import 'package:cleanconnectortab/Screen/incident_report.dart';
import 'package:cleanconnectortab/Screen/notificationScreen.dart';
import 'package:cleanconnectortab/Screen/site%20logout%20form.dart';
// import 'package:cleanconnectortab/Screen/site%20logout%20form.dart';
import 'package:cleanconnectortab/Screen/site_recomondation.dart';
import 'package:cleanconnectortab/Stock.dart';
import 'package:cleanconnectortab/Timer.dart';
import 'package:cleanconnectortab/constants/DashboardCard.dart';
import 'package:cleanconnectortab/incident_report_form.dart';
import 'package:cleanconnectortab/login.dart';
// import 'package:cleanconnectortab/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'Models/Card_model.dart';
import 'Screen/SiteManual.dart';
// import 'Screen/site logout form.dart';
import 'Screen/incident.dart';
import 'SiteInfo.dart';
import 'constants/const_api.dart';
import 'constants/style.dart';
import 'logoutButton.dart';

Map<String, dynamic> loginUserProfile = {
  'id': '',
  'fname': '',
  'lname': '',
  'phone': '',
  'email': '',
  'image': '',
  'startDate': '',
  'endDate': '',
  'siteId': '',
  'site_name': '',
  "site_address": "",
  "rate": "",
};
bool loginStatus = false;
bool siteLogout = false;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      title: 'Site Recommendation',
      subtitle: 'Donat Twerski',
      rating: 'ASSETS',
      cookTime: '3m',
      customIcon: Icons.recommend_outlined,
      status: 'OPEN',
      thumbnailUrl: 'assets/images/Recommendation_1.png',
    ),
    CardModel(
      title: 'Help',
      subtitle: 'Donat Twerski',
      rating: 'ASSETS',
      cookTime: '3m',
      customIcon: Icons.help_outline,
      status: 'OPEN',
      thumbnailUrl: 'assets/images/Help_1.jpg',
    ),
  ];

  // final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String profilePic = '';
  String name = '';
  String email = '';
  String date = '';

  Future getProfile() async {
    print("Data loading....2");
    setState(() {
      isLoading = true;
    });
    print(loginSiteData['accessToken']);
    // print("${loginUserProfile['id']}");
    // String id = loginUserData['id'];
    // print(loginUserData['id']);
    try {
      print("+++++++++++>" + loginSiteData['id']);
      // ${loginUserData['id']}
      final response = await Dio().get(
          '${BASE_API2}site/get-sites/${loginSiteData['id']}',
          options: Options(headers: {
            "Authorization": "Bearer " + loginSiteData['accessToken']
          }));
      print(response.statusCode);
      print(response.data['status']);
      if (response.statusCode == 200 && response.data['status'] == true) {
        print(response.data['sites']);
        print("Result");
        print(response.data['sites'][0]['site_name']);
        setState(() {
          loginUserProfile['id'] = response.data['sites'][0]['site_id'] ?? " ";
          loginUserProfile['name'] =
              response.data['sites'][0]['site_address'] ?? " ";
          loginUserProfile['phone'] =
              response.data['sites'][0]['mobile'] ?? " ";
          loginUserProfile['email'] =
              response.data['sites'][0]['site_email'] ?? " ";
          // loginUserProfile['image'] = response.data['result'][0]['image'] ?? " ";
          loginUserProfile['site_name'] =
              response.data['sites'][0]['site_name'] ?? " ";
          loginUserProfile['rate'] =
              response.data['sites'][0]['rate'].toString() ?? " ";
        });
        print(loginUserProfile['name']);
        print(loginUserProfile['id']);
        print(loginUserProfile['rate']);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    loginStatus = false;
    isLoading = true;
    loading();
    // if (loginUserProfile['dob'] != null) {
    //   final dateParts = loginUserProfile['dob'].split('T')[0].split('-');
    //   if (dateParts.length == 3) {
    //     final year = int.parse(dateParts[0]);
    //     final month = int.parse(dateParts[1]);
    //     final day = int.parse(dateParts[2]);
    //     DateTime dob = DateTime(year, month, day);
    //     setState(() {
    //       date = DateFormat("yyyy-MM-dd").format(dob);
    //     });
    //   } else {
    //     date = 'Invalid Date';
    //   }
    // } else {
    //   date = 'No Date Provided';
    // }

    // Get.closeAllSnackbars;
    super.initState();
    print("???????????????????");
  }

  loading() async {
    await getProfile();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "${loginUserProfile['site_name']} - ${loginUserProfile['name']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  siteLogout = true;
                });
                _onBackButtonPressed(context);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: kiconColor,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.settings,
                    color: kiconColor,
                  ),
                ),
              )),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: GestureDetector(
                  onTap: () async {
                    
                    if (loginSiteData['userType'] != 'cleaner') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      }
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: kiconColor,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.email,
                        color: kiconColor,
                      ),
                    ),
                  ))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(8.0), // Add rounded corners
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      blurRadius: 2,
                    )
                  ],
                ),
                // height: screenHeight,
                width: screenWidth * 0.3,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        // height: Size.height/2,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            image: const AssetImage(
                              'assets/images/color_logo.png',
                            ),
                            color: kiconColor,
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => TimerScreen()));
                    //   },
                    //   child: Icon(
                    //     Icons.fingerprint,
                    //     color: kiconColor,
                    //     size: 50,
                    //   ),
                    // ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Place your finger to Login\n",
                                  style: TextStyle(
                                      color: kiconColor, fontSize: 15),
                                  // onPressed: () async {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               TimerScreen()));
                                  // },
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                loginStatus = true;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TimerScreen()));
                            },
                            child: Icon(
                              Icons.fingerprint,
                              color: kiconColor,
                              size: 50,
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "\nOr \n",
                                  style: TextStyle(
                                      color: kiconColor, fontSize: 15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the login with email screen here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CleanerLoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Login with Email",
                                    style: TextStyle(
                                        color: kiconColor, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: VerticalDivider(
                  thickness: 2, // Adjust the thickness as needed
                  color: kiconColor, // Choose a color for the divider
                ),
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(8.0), // Add rounded corners
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          blurRadius: 2,
                        )
                      ],
                    ),
                    child: GridView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,

                        //childAspectRatio: screenHeight / 280,

                        childAspectRatio: screenHeight / 350,

                        // Two columns
                      ),
                      itemCount: recipeCards.length, // Total number of items
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            // Check the custom icon and navigate accordingly
                            if (recipeCards[index].title == 'Stock') {
                              // Navigate to CommunicationPage
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Stock()));
                            } else if (recipeCards[index].title == 'Help') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HelpDash()));
                            } // Add more cases for other custom icons as needed
                            else if (recipeCards[index].title ==
                                'Tool Box Talk') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ToolBoxtTalk()));
                            } else if (recipeCards[index].title ==
                                'Communication') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommunicationScreen()));
                            } else if (recipeCards[index].title ==
                                'Site Information') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SiteInformation()));
                            } else if (recipeCards[index].title ==
                                'Site Recommendation') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SiteRecomondationScreen()));
                            } else if (recipeCards[index].title ==
                                'Site Manual') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SiteManual()));
                            } else if (recipeCards[index].title ==
                                'Incident Report') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IncidentReport()));
                            }
                          },
                          child: DashboardCardModel(
                            title: recipeCards[index].title,
                            subtitle: recipeCards[index].subtitle,
                            rating: recipeCards[index].rating,
                            cookTime: recipeCards[index].cookTime,
                            customIcon: recipeCards[index].customIcon,
                            status: recipeCards[index].status,
                            thumbnailUrl: recipeCards[index].thumbnailUrl,
                          ),
                        );
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Logout ?",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            content: const Text(
              'Do you want to log out from site?',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 16, color: kiconColor),
                  )),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      logOut(context);
                    });
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 16, color: kiconColor),
                  )),
            ],
          );
        });
    return exitApp ?? false;
  }

  static logOut(context) async {
    Navigator.of(context).push(
      // the new route
      MaterialPageRoute(
        builder: (BuildContext context) => SiteLogoutScreen(),
      ),
    );
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
