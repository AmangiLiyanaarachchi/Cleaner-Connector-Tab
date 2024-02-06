import 'dart:async';
import 'package:cleanconnectortab/Communication.dart';
import 'package:cleanconnectortab/Dashboard.dart';
import 'package:cleanconnectortab/Screen/Help_Dashboard.dart';
import 'package:cleanconnectortab/Screen/incident.dart';
import 'package:cleanconnectortab/Screen/incident_Report/incident_report.dart';
import 'package:cleanconnectortab/Screen/notificationScreen.dart';
import 'package:cleanconnectortab/Stock.dart';
import 'package:cleanconnectortab/constants/DashboardCard.dart';
import 'package:cleanconnectortab/login.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioo;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CleanerLogin.dart';
import 'Screen/SiteManual.dart';
import 'Screen/SiteManual_Admin.dart';
// import 'Screen/ToolBoxTalk.dart';
import 'Screen/ToolBoxTalk.dart';
import 'Screen/help_screen.dart';
// import 'Screen/incident_report.dart';
import 'Screen/site_recomondation.dart';
import 'SiteInfo.dart';
import 'constants/const_api.dart';
import 'constants/style.dart';
import 'logoutButton.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String formattedDuration =
      '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  return formattedDuration;
}

String _twoDigits(int n) {
  if (n >= 10) {
    return '$n';
  }
  return '0$n';
}

class _TimerState extends State<TimerScreen> {
  DateTime? onTime;
  static int get maxSeconds => 00;
  static int get maxMin => 00;
  static int get maxHours => 00;
  DateTime? startTime; // Replace with your start time
  DateTime endTime = DateTime.now(); // Replace with your end time
  int sec = 00;
  int min = 00;
  int hour = 00;
  bool _isDisable = false;
  bool _isDisableStop = false;
  String? _noResponse;
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
      thumbnailUrl: 'assets/images/Stoke_2.jpg',
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

  static logOut(context) async {
    //final prefs = await SharedPreferences.getInstance();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('id', '');
    await sharedPreferences.setString('userType', '');
    await sharedPreferences.setString('email', '');
    await sharedPreferences.setBool('login', false);
    //prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      // the new route
      MaterialPageRoute(
        builder: (BuildContext context) => const Dashboard(),
      ),

      // this function should return true when we're done removing routes
      // but because we want to remove all other screens, we make it
      // always return false
      (Route route) => false,
    );
  }

  Future onStart() async {
    try {
      print("xxxx");
      var response = await Dio().put(
          '${BASE_API2}tasks/start-task/${loginCleanerData['record_id']}',
          data: {"start_gps": loginUserProfile['name']},
          options: Options(headers: {
            "Authorization": "Bearer " + loginCleanerData["accessToken"]
          }));
      print("!!!!!!!!!!$response");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('User ID *************');
        startTimer();
        setState(() {
          _isDisable = true;
          _isDisableStop = false;
          loginCleanerData['isStart'] = "true";
          loginCleanerData['Start_time'] = DateTime.now();
          //isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 5,
              left: 5),
        ));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        print("Bad Error");
        print(e.response?.data["message"]);
        if (e.response?.data["message"] == "Cleaner Password is incorrect") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid Password."),
            ),
          );
        }
        if (e.response?.data["message"] == "User email not exist") {
        } else if (e.response?.data["message"] ==
            "No any registered user for this email") {}
      }
      print(e.toString());
      print(e);
    }
  }

  Future onEnd() async {
    try {
      print("xxxx");
      var response = await Dio().put(
          '${BASE_API2}tasks/end-task/${loginCleanerData['record_id']}',
          data: {"end_gps": loginUserProfile['name']},
          options: Options(headers: {
            "Authorization": "Bearer " + loginCleanerData["accessToken"]
          }));
      print("!!!!!!!!!!$response");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('User ID *************');
        stopTimer();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
        setState(() {
          _isDisable = false;
          loginCleanerData['isStart'] = "false";
          //isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 5,
              left: 5),
        ));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        print("Bad Error");
        print(e.response?.data["message"]);
        if (e.response?.data["message"] == "Cleaner Password is incorrect") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid Password."),
            ),
          );
        }
        if (e.response?.data["message"] == "User email not exist") {
        } else if (e.response?.data["message"] ==
            "No any registered user for this email") {}
      }
      print(e.toString());
      print(e);
    }
  }

  Future forgotToLogout() async {
    try {
      print("xxxx");
      var response = await Dio().put(
          '${BASE_API2}tasks/end-forgot-task/${loginCleanerData['record_id']}',
          data: {"end_gps": loginUserProfile['name']},
          options: Options(headers: {
            "Authorization": "Bearer " + loginCleanerData["accessToken"]
          }));
      print("!!!!!!!!!!$response");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('User ID *************');
        stopTimer();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
        setState(() {
          _isDisable = false;
          loginCleanerData['isStart'] = "false";
          //isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something went wrong. Please try again'),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 5,
              left: 5),
        ));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        print("Bad Error");
        print(e.response?.data["message"]);
        if (e.response?.data["message"] == "Cleaner Password is incorrect") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid Password."),
            ),
          );
        }
        if (e.response?.data["message"] == "User email not exist") {
        } else if (e.response?.data["message"] ==
            "No any registered user for this email") {}
      }
      print(e.toString());
      print(e);
    }
  }

  Timer? timer;
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec < 59) {
        setState(() {
          sec++;
        });
      } else if (sec >= 59) {
        setState(() {
          min++;
          resetTimer();
        });
      } else if (min >= 59) {
        setState(() {
          hour++;
          min = maxMin;
        });
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    timer?.cancel();
    setState(() {
      min = maxMin;
      sec = maxSeconds;
      hour = maxHours;
    });
  }

  void resetTimer() {
    setState(() {
      sec = maxSeconds;
    });
  }

  // final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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

  Future getProfile() async {
    print("Data loading....2");
    setState(() {
      isLoading = true;
    });
    print(loginSiteData["accessToken"]);
    // print("${loginUserProfile['id']}");
    // String id = loginUserData['id'];
    // print(loginUserData['id']);
    try {
      print("+++++++++++>" + loginSiteData['id']);
      // ${loginUserData['id']}
      final response = await Dio().get(
          '${BASE_API2}site/get-sites/${loginSiteData['id']}',
          options: Options(headers: {
            "Authorization": "Bearer " + loginSiteData["accessToken"]
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
    _startTimer();
    isLoading = true;
    if (loginCleanerData['isStart'] == "true") {
      startTimer();
      setState(() {
        startTime = DateTime.parse(loginCleanerData['Start_time']);
        endTime = DateTime.now();
        _isDisable = true;
      });
      Duration duration = endTime.difference(startTime!);
      String formattedDuration = formatDuration(duration);
      print(endTime.toString());
      print(startTime.toString());
      print("Formatted duration: $formattedDuration");
      var splitetime = formattedDuration.split(':');
      String hourx = splitetime[0];
      String minx = splitetime[1];
      String secx = splitetime[2];
      print("hour $hourx");
      print("min $minx");
      print("sec $secx");
      setState(() {
        min = int.parse(minx);
        sec = int.parse(secx);
        hour = int.parse(hourx);
      });
    }
    if (loginCleanerData['isStart'] == "logged" ||
        loginCleanerData['isStart'] == "false") {
      setState(() {
        _isDisableStop = true;
      });
    }
    loading();
    super.initState();
    print("???????????????????");
  }

  @override
  void dispose() {
    if (_timer != null)
    {
      print(_timer);
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  loading() async {
    await getProfile();
    setState(() {
      isLoading = false;
    });
  }

  void timeOutCallBack() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()),);
  }

  Timer? _timer;
  _startTimer() {
    print("Timer reset ${DateTime.now()}");
    if (_timer != null)
    {
      print(_timer);
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer(const Duration(minutes: 1), (){
      print("Time to logout ${DateTime.now()}");
      _startLogoutTimer();
      _onTimeOut(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (_)
          {
            _startTimer();
          },
          child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "${loginUserProfile['site_name']} - ${loginUserProfile['name']}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: const logoutButton(),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                    child: const CircleAvatar(
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
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Image(
                              image: AssetImage(
                                'assets/images/color_logo.png',
                              ),
                              color: kiconColor,
                              height: 150,
                              width: 150,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildTime(),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (loginCleanerData['isStart'] ==
                                            "false") {
                                          await onStart();
                                          setState(() {
                                            onTime = DateTime.now();
                                            print("Start time: $onTime");
                                            print(
                                                "Previous Start time: ${loginCleanerData['Start_time']}");
                                          });
                                        } else if (loginCleanerData['isStart'] ==
                                            "logged") {
                                          print(
                                              "logged in another site. please logout");
                                          _showAddTopicDialog(context);
                                        } else {
                                          print(
                                              "Previous Start time: ${loginCleanerData['Start_time']}");
                                        }
                                      },
                                      child: const Text(
                                        'Start',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: _isDisable
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.grey)
                                            : MaterialStateProperty.all<Color>(
                                                kiconColor), // Change the color here
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_isDisableStop == true) {
                                          print("Disable");
                                        } else {
                                          await onEnd();
                                          print("Timer Stop");
                                        }
                                      },
                                      child: const Text(
                                        'Finish',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: _isDisableStop == true
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.grey)
                                            : MaterialStateProperty.all<Color>(
                                                kiconColor), // Change the color here
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.play_circle,
                                    color: kiconColor,
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        _onBackButtonPressed(context);
                                      },
                                      child: const Text(
                                        'Log Out',
                                        style: TextStyle(
                                            fontSize: 25, color: kiconColor),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const Stock()));
                          } else if (recipeCards[index].title == 'Help') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpDash()));
                          } // Add more cases for other custom icons as needed
                          else if (recipeCards[index].title == 'Tool Box Talk') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ToolBoxtTalk()));
                          } else if (recipeCards[index].title ==
                              'Communication') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommunicationScreen()));
                          } else if (recipeCards[index].title ==
                              'Site Information') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SiteInformation()));
                          } else if (recipeCards[index].title ==
                              'Site Recommendation') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SiteRecomondationScreen()));
                          } else if (recipeCards[index].title == 'Site Manual') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SiteManual()));
                          } else if (recipeCards[index].title ==
                              'Incident Report') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Incident()));
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
                  ),
                ))
              ],
            ),
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
              'Do you want to log out?',
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
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('token');
                    prefs.remove('id');
                    prefs.remove('userType');
                    prefs.remove('email');
                    prefs.remove('fname');
                    prefs.remove('lname');
                    prefs.remove('siteId');
                    setState(() {
                      loginStatus = false;

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

  Timer? logoutTimer;
  _startLogoutTimer() {
    print("start logout timer at ${DateTime.now()}");
    if (logoutTimer != null)
    {
      print(logoutTimer);
      logoutTimer?.cancel();
      logoutTimer = null;
    }
    logoutTimer = Timer(const Duration(seconds: 30), () async {
      print("No response. So, time to logout ${DateTime.now()}");
      if(_noResponse != "false") {
          SharedPreferences prefs =
          await SharedPreferences.getInstance();
          prefs.remove('token');
          prefs.remove('id');
          prefs.remove('userType');
          prefs.remove('email');
          prefs.remove('fname');
          prefs.remove('lname');
          prefs.remove('siteId');
          setState(() {
            loginStatus = false;
            setState(() {
              _noResponse = "true";
            });
            logOut(context);
          });
      }
    });
  }

  Future<bool> _onTimeOut(BuildContext context) async {
    setState(() {
      _noResponse = "true";
    });
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Do you want to continue?',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.remove('token');
                    prefs.remove('id');
                    prefs.remove('userType');
                    prefs.remove('email');
                    prefs.remove('fname');
                    prefs.remove('lname');
                    prefs.remove('siteId');
                    setState(() {
                      loginStatus = false;
                      setState(() {
                        _noResponse = "false";
                      });
                      logOut(context);
                    });
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 16, color: kiconColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _startTimer();
                    setState(() {
                      _noResponse = "false";
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

  Widget buildTime() {
    return Text(
      "${_twoDigits(hour)} : ${_twoDigits(min)} : ${_twoDigits(sec)}",
      // (min <= 9 && sec <= 9)
      //     ? "0${min.toString()} : 0${sec.toString()}"
      //     : (min >= 9 && sec <= 9)
      //         ? "${min.toString()} : 0${sec.toString()}"
      //         : (min <= 9 && sec >= 9)
      //             ? "0${min.toString()} : ${sec.toString()}"
      //             : "${min.toString()} : ${sec.toString()}",
      style: const TextStyle(fontSize: 20, color: Colors.black),
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              "Still work with another site. Please stop timer before start work here."),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                child: const Text(
                  'Proceed from here and Inform the client',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await forgotToLogout(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text(
                  'I\'ll go there and Finish it',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
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
