import 'package:cleanconnectortab/Communication.dart';
import 'package:cleanconnectortab/Controller/authController.dart';
import 'package:cleanconnectortab/Dashboard.dart';
import 'package:cleanconnectortab/Timer.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:cleanconnectortab/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:io';

import 'package:cleanconnectortab/AdminLogin.dart';
import 'package:cleanconnectortab/communication_cleaner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message {
  final String senderName;
  final String text;
  final DateTime timestamp; // Add a timestamp field
  final File? imageFile; // Add an optional image file field

  Message(this.senderName, this.text, this.timestamp, {this.imageFile});
}

class ChatHistory extends StatefulWidget {
  ChatHistory({required this.logoutEnable});
  bool logoutEnable;
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  final ChatServices chatServices = ChatServices();
  String searchValue = '';
  String chatRoomId = '';
  String uesrId = '';
  String title = '';
  String userType = "";

  bool loginStatus = false;
  // File? _pickedImage;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loginData();
  }

  final String _userName = "Taniya";
  String _selectedOption = 'Select Cleaner';
  final ImagePicker _imagePicker = ImagePicker();

  final List<Message> _messages = [
    Message("Cleaner 2", "Completed Task", DateTime.now()),
    Message("Cleaner 1", "Completed Task", DateTime.now()),
    Message("Admin", "Need to dust 1st floor", DateTime.now()),
  ];

  bool isChatOpen = false;

  PickedFile? _image;

  // Function to open the gallery and select an image
  // Future<void> _pickImage() async {
  //   final pickedImage =
  //       await _imagePicker.getImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _pickedImage = File(pickedImage.path);
  //     });
  //   }
  // }

  void _showAddTopicDialog(BuildContext context) {
    String topic = ""; // Store the topic entered by the user

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Before Create the New Chat, Enter the Title: "),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter a topic",
                ),
                onChanged: (value) {
                  topic = value; // Update the topic when the user types
                },
              ),
              const SizedBox(
                  height: 20), // Add spacing between TextField and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "Add",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      if (topic.isNotEmpty) {
                        // Only navigate if the topic is not empty
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminLoginScreen()));
                      } else {
                        // Show an error message or prevent navigation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a topic."),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String siteId = '';
  String adminSiteId = " ";
  void loginData() async {
    //Get logged user data
    Map<String, dynamic> userData = await AuthController.getLoginData();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    adminSiteId = await sharedPreferences.getString('Client siteId').toString();
    print(userData.toString());
    setState(() {
      siteId = userData['siteId'];
      uesrId = userData['id'];
      userType = userData['userType'];
      loginStatus = sharedPreferences.getBool('login')!;
    });
    print('siteId ' + siteId);
  }

  //build a list of chats
   Widget _buildUserList(BuildContext context) {
    if (searchController.text.isEmpty) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where('active', isEqualTo: false)
              .where('site_id', )
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Text('error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('loading...');
            }
            return ListView(
              children: snapshot.data!.docs
                  .map<Widget>(
                      (doc) => _buildUserListItem(context, doc, doc.id))
                  .toList(),
            );
          }));
    } else {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where('site_id')
              .where('active', isEqualTo: false)
              .where('title_lowercase', isGreaterThanOrEqualTo: searchValue)
              .where('title_lowercase', isLessThan: searchValue + 'z')
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('error' + snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('loading...');
            }
            return ListView(
              children: snapshot.data!.docs
                  .map<Widget>(
                      (doc) => _buildUserListItem(context, doc, doc.id))
                  .toList(),
            );
          }));
    }
  }

//build single chat card
  Widget _buildUserListItem(
      BuildContext context, documentSnapshot, String docId) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isChatOpen = true;
                  chatRoomId = docId;
                  title = data['title'];
                });
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        data['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Add other chat card content here
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(), // Add Spacer to control the space
                          Text(
                            data['created_by_name'] == "null null"
                                ? "Admin"
                                : data['created_by_name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              color: Colors.black, // Adjust the color as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

//build msg list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: chatServices.getMessages(chatRoomId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ' + snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          return ListView(
            children:
                snapshot.data!.docs.map((e) => _buildMessageItem(e)).toList(),
          );
        });
  }
 String currentFormattedDate = '';
  String previousFormattedDate = '';
  bool firstMessagePassed = false;
  int noOfMessages = 0;
  int noOfdisplayedMessages = 0;
  //build msg item
  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
     bool showDate = false;
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    // Ailgn messages to the right if the sender is the current user, otherwise to the left
    print(data['senderId'] + '........' + uesrId);
    print(data['senderId'] + '........' + loginStatus.toString());
    var isCurrentUser = (data['senderId'] == uesrId); //need to get login id
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.Hm().format(dateTime);
     String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);


     //date show
    if (!firstMessagePassed) {
      showDate = true;
      currentFormattedDate = formattedDate;
      previousFormattedDate = formattedDate;
    } else {
      currentFormattedDate = formattedDate;
    }
    print(currentFormattedDate);
    if (currentFormattedDate != previousFormattedDate ||
        noOfMessages == noOfdisplayedMessages) {
      showDate = true;

      previousFormattedDate = formattedDate;
    }
    firstMessagePassed = true;
    noOfdisplayedMessages++;

    var alignment;
    if (isCurrentUser) {
      alignment = Alignment.centerRight;
    } else {
      alignment = Alignment.centerLeft;
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
         if (showDate)
          Stack(
            alignment: Alignment.center,
            children: [
              Divider(
                height: 5,
                color: Colors.grey[350],
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300]),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(formattedDate),
                  )),
            ],
          ),
        Align(
          alignment: loginStatus ? alignment : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isCurrentUser && loginStatus
                  ? Colors.blueGrey[100]
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrentUser && loginStatus
                      ? "You"
                      : data['senderName'] == "null null"
                          ? 'Admin'
                          : data['senderName'],
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: isCurrentUser && loginStatus
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4.0),
                if (data['message'] != "")
                  Text(
                    data['message'],
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 4.0),
                if (data['subMessage'] != "")
                  Text(
                    data['subMessage'],
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 68, 65, 65),
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w600),
                  ),
                if (data['imageUrl'] != "")
                  Image.network(
                    data['imageUrl'],
                    height: 250.0,
                    width: 250.0,
                  ),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: isCurrentUser && loginStatus
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
              'Do you want to log out from communication ?',
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
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    await sharedPreferences.setBool('login', false);

                    await sharedPreferences.setString('userId', '');
                    await sharedPreferences.setString('id', '');
                    await sharedPreferences.setString('userType', '');
                    setState(() {
                      widget.logoutEnable = false;
                    });
                    loginData();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()));
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            loginStatus ? "COMMUNICATION" : "COMMUNICATION - View Only",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            widget.logoutEnable
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        _onBackButtonPressed(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                        ),
                      ),
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : loginStatus
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminLoginScreen(),
                              ),
                            ).then(
                              (value) async {
                                if (value) {
                                  setState(() {
                                    widget.logoutEnable = true;
                                    loginData();
                                  });
                                  print('Admin Logged');
                                }
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the radius as needed
                              ),
                            ),
                          ),
                          child: Text(
                            "Admin Login",
                            style: TextStyle(
                              fontFamily: "Open Sans",
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
          ],
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                loginStatus == true
                    ? Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => TimerScreen(),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()));
              },
              child: const CircleAvatar(
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
        body: WillPopScope(
          onWillPop: () async {
            loginStatus == true && userType == 'cleaner'
                ? Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (_) => TimerScreen(),
                    ),
                  )
                : loginStatus == true && userType == 'client'
                    ? _onBackButtonPressed(context)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()));

            // Return true to allow back navigation, or false to disable it
            return false;
          },
          child: Container(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
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
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      // Replace 'ChatHistoryPage()' with the actual widget for your chat history page.
                                      return CommunicationScreen(
                                        logoutEnable: widget.logoutEnable,
                                      );
                                    },
                                  ));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Active Chat List",
                                  style: TextStyle(
                                    fontFamily: "Open Sans",
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                height: 35.0, // Adjust the height as needed
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    hintStyle: const TextStyle(
                                      // Add styles for the hint text here
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical:
                                          10.0, // Adjust the vertical padding to move hint text to the top
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      searchValue = text;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              child: const Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "Chat History",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: _buildUserList(context),
                            ),
                            // loginStatus == true
                            //     ? Padding(
                            //         padding: EdgeInsets.only(
                            //           left: screenWidth * 0.22,
                            //           bottom: 10,
                            //         ),
                            //         child: Align(
                            //           alignment: Alignment.bottomRight,
                            //           child: FloatingActionButton.small(
                            //             onPressed: () {
                            //               showDialog(
                            //                 context: context,
                            //                 builder: (BuildContext context) {
                            //                   return AlertDialog(
                            //                     title: Text(
                            //                         'Choose your user type:'),
                            //                     content: Column(
                            //                       mainAxisSize:
                            //                           MainAxisSize.min,
                            //                       children: [
                            //                         ListTile(
                            //                           title: ElevatedButton(
                            //                             onPressed: () {
                            //                               _showAddTopicDialog(
                            //                                   context);
                            //                             },
                            //                             style: ElevatedButton
                            //                                 .styleFrom(
                            //                               backgroundColor:
                            //                                   Colors.black,
                            //                             ),
                            //                             child: const Text(
                            //                               'Admin',
                            //                               style: TextStyle(
                            //                                 fontFamily:
                            //                                     "Open Sans",
                            //                                 fontSize: 15,
                            //                                 color: Colors.white,
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         ListTile(
                            //                           title: ElevatedButton(
                            //                             onPressed: () {
                            //                               Navigator.push(
                            //                                   context,
                            //                                   MaterialPageRoute(
                            //                                       builder:
                            //                                           (context) =>
                            //                                               Communication_Cleaner(
                            //                                                 title:
                            //                                                     '',
                            //                                               )));
                            //                             },
                            //                             style: ElevatedButton
                            //                                 .styleFrom(
                            //                                     backgroundColor:
                            //                                         Colors
                            //                                             .black),
                            //                             child: const Text(
                            //                               'Cleaner',
                            //                               style: TextStyle(
                            //                                   fontFamily:
                            //                                       "Open Sans",
                            //                                   fontSize: 15,
                            //                                   color:
                            //                                       Colors.white),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   );
                            //                 },
                            //               );
                            //             },
                            //             backgroundColor: Colors.black,
                            //             child: const Icon(
                            //               Icons.add,
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     : SizedBox(),
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
                      Visibility(
                        visible: isChatOpen,
                        child: Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  8.0), // Add rounded corners
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                )
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  // Add a heading here
                                  Row(
                                    children: [
                                      Card(
                                        elevation:
                                            4, // Add elevation for shadow
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Add border radius
                                        ),
                                        child: Container(
                                          width: screenWidth * 0.55,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 50,
                                              right: 50,
                                              bottom: 10),
                                          child: Text(
                                            title,
                                            textAlign: TextAlign
                                                .center, // Change the text as needed
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          child: IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.white),
                                            onPressed: () {
                                              setState(() {
                                                isChatOpen =
                                                    !isChatOpen; // Toggle chat visibility
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Expanded(
                                      child: chatRoomId.isEmpty
                                          ? Container()
                                          : _buildMessageList()),

                                  // const Divider(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
