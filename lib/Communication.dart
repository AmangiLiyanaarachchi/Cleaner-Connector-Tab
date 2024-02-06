import 'dart:async';

import 'package:cleanconnectortab/Controller/authController.dart';
import 'package:cleanconnectortab/Screen/chat_history.dart';
import 'package:cleanconnectortab/Screen/site%20logout%20form.dart';
import 'package:cleanconnectortab/communication_admin.dart';
import 'package:cleanconnectortab/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'Dashboard.dart';
import 'Timer.dart';
import 'constants/style.dart';
import 'dart:io';

import 'package:cleanconnectortab/AdminLogin.dart';
import 'package:cleanconnectortab/communication_cleaner.dart';

class Message {
  final String senderName;
  final String text;
  final DateTime timestamp; // Add a timestamp field
  final File? imageFile; // Add an optional image file field

  Message(this.senderName, this.text, this.timestamp, {this.imageFile});
}

class CommunicationScreen extends StatefulWidget {
  CommunicationScreen({this.logoutEnable = false});
  bool logoutEnable;
  @override
  _CommunicationScreenState createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _textController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final ChatServices chatServices = ChatServices();

  // File? _pickedImage;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loginData();
  }

  String searchValue = '';
  String chatRoomId = '';
  String uesrId = '';
  String title = '';
  String imageUrl = '';
  String userType = "";
  String createdby = " ";

  bool isChatOpen = false;
  // bool logoutEnable = false;

  void sendMessages() async {
    print('Inside Send Messages');

    await chatServices.sendMessages(chatRoomId, _textController.text,
        imageUrl: imageUrl);
    _textController.clear();
  }

  void _showAddTopicDialog(BuildContext context, String user) {
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
                    onPressed: () async {
                      if (topic.isNotEmpty) {
                        // Only navigate if the topic is not empty
                        if (user == "cleaner") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Communication_Cleaner(
                                        title: topic,
                                      )));
                        } else if (user == "client") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Communication_Admin(
                                        title: topic,
                                      )));
                        }
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

  String adminSiteId = " ";
  String siteId = '';
  void loginData() async {
    //Get logged user data
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userData = await AuthController.getLoginData();
    adminSiteId = await sharedPreferences.getString('Client siteId').toString();
    print(userData.toString());

    setState(() {
      siteId = userData['siteId'];
      uesrId = userData['id'];
      userType = userData['userType'];
      loginStatus = sharedPreferences.getBool('login')!;
    });
    print(userType);

    print('siteId ' + siteId);
  }

  Future<String?> _pickImageFromGallery() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Define a unique filename for the image using a timestamp
        String filename = path.basename(pickedFile.path);

        // Upload the image to Firebase Storage
        final storageReference = _storage.ref().child('Comm_Chats/$filename');
        UploadTask uploadTask = storageReference.putFile(imageFile);

        // Create a Completer to wait for the upload to complete
        Completer<String?> uploadCompleter = Completer<String?>();

        // Listen for the state changes, including errors and completion
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) async {
          if (snapshot.state == TaskState.success) {
            // The upload is complete, obtain the download URL
            imageUrl = await storageReference.getDownloadURL();
            print(imageUrl);

            // Resolve the Completer with the imageUrl
            uploadCompleter.complete(imageUrl);
          } else if (snapshot.state == TaskState.error) {
            // Handle any errors here
            uploadCompleter.completeError('Image upload failed');
          }
        });

        // Show a loading indicator while uploading
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: 300.0,
                height: 300.0,
                child: FutureBuilder<String?>(
                  future: uploadCompleter.future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Image upload failed');
                    } else if (snapshot.hasData) {
                      return Image.file(imageFile);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    sendMessages();
                    imageUrl = "";
                    // Close the preview
                    Navigator.pop(context, uploadCompleter.future);
                  },
                  child: Text('Send'),
                ),
                TextButton(
                  onPressed: () {
                    // Close the preview
                    Navigator.pop(context, null);
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );

        // Wait for the user to decide (Send or Cancel)
        return await uploadCompleter.future;
      }

      return null;
    } catch (e) {
      print(e.toString());
    }
  }

//build a list of chats
   Widget _buildUserList(BuildContext context) {
    if (searchController.text.isEmpty) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where('active', isEqualTo: true)
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
              .where('active', isEqualTo: true)
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
                  createdby = data['created_by'];
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


  //delete msg pop up
  void _showDeleteDialog(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Delete Message ')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  onPressed: () async {
                    print("messageId" + messageId);
                    Navigator.of(context).pop();
                    chatServices.deleteMessage(chatRoomId, messageId);
                  },
                  child: Text("Delete"))
            ],
          ),
        );
      },
    );
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

    var isCurrentUser = (data['senderId'] == uesrId); //need to get login id
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.Hm().format(dateTime);
    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    print('$noOfMessages + ->+ $noOfdisplayedMessages');

    
    var alignment;


    print('loginStatus' + loginStatus.toString());

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

     String subMessage =
        "Assigned to: ${data['receiverName']}\nPriority level: ${data['priorityLevel']}";

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
        GestureDetector(
           onLongPress: () {
                // if (isCurrentUser) {
                //   _showDeleteDialog(context, documentSnapshot.id);
                // }
              },
          child: Align(
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
                      color: isCurrentUser ? Colors.black : Colors.grey[600],
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
                    if (data['receiverName'] != "")
                    Text(
                     subMessage,
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
                      color: isCurrentUser ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ],
              ),
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
            "COMMUNICATION" ,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
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
                                      return ChatHistory(
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
                                  "Chat History",
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
                                      "Active Chat List",
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
                            (loginStatus)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: screenWidth * 0.22,
                                      bottom: 10,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: FloatingActionButton.small(
                                        onPressed: () {
                                          _showAddTopicDialog(
                                              context, userType);
                                        },
                                        backgroundColor: Colors.black,
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
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

                                  (loginStatus == true)
                                      ? Column(
                                          children: [
                                            const Divider(),
                                            ListTile(
                                              // leading: const Icon(Icons.message,
                                              //     color: Color.fromARGB(255, 52, 137, 207)),
                                              title: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                              8.0), // Optional padding
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10), // Optional border radius
                                                        border: Border.all(
                                                            color: Colors
                                                                .black), // Optional border
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Icon(
                                                                Icons.message,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Expanded(
                                                            child: TextField(
                                                              controller:
                                                                  _textController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    'Enter what you need', // Include the selected emoji here
                                                                hintStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons
                                                                    .attachment,
                                                                color: Colors
                                                                    .black),
                                                            onPressed:
                                                                () async {
                                                              _pickImageFromGallery();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  // DropdownButton<String>(
                                                  //   value: _selectedOption,
                                                  //   onChanged: (newValue) {
                                                  //     setState(() {
                                                  //       _selectedOption =
                                                  //           newValue!;
                                                  //     });
                                                  //   },
                                                  //   items: <String>[
                                                  //     'Select Cleaner',
                                                  //     'Cleaner 1',
                                                  //     'Cleaner 2',
                                                  //     'Cleaner 3',
                                                  //     'Cleaner 4',
                                                  //     // Add your dropdown options here
                                                  //   ].map<
                                                  //       DropdownMenuItem<String>>(
                                                  //     (String value) {
                                                  //       return DropdownMenuItem<
                                                  //           String>(
                                                  //         value: value,
                                                  //         child: Text(
                                                  //           value,
                                                  //           style:
                                                  //               const TextStyle(
                                                  //             fontFamily:
                                                  //                 "Open Sans",
                                                  //             fontSize: 15,
                                                  //           ),
                                                  //         ),
                                                  //       );
                                                  //     },
                                                  //   ).toList(),
                                                  // ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.send,
                                                          color: Colors.white),
                                                      onPressed: sendMessages,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            uesrId == createdby
                                                ? GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "End Chat",
                                                            ),
                                                            content: Text(
                                                                "Are you sure you want to end the chat?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'chat_rooms')
                                                                      .doc(
                                                                          chatRoomId) // Assuming 'chatRoomId' is the document ID
                                                                      .update({
                                                                    'active':
                                                                        false
                                                                  });
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ChatHistory(
                                                                        logoutEnable:
                                                                            widget.logoutEnable,
                                                                      ),
                                                                    ),
                                                                  ); // Close the dialog
                                                                },
                                                                child:
                                                                    Text("Yes"),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child:
                                                                    Text("No"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "End the Chat",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        )
                                      : SizedBox()
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
