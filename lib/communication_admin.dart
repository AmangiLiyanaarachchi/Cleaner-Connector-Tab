import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cleanconnectortab/Communication.dart';
import 'package:cleanconnectortab/Controller/authController.dart';
import 'package:cleanconnectortab/constants/const_api.dart';
import 'package:cleanconnectortab/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'constants/style.dart';

class Message {
  final String senderName;
  final String text;
  final DateTime timestamp; // Add a timestamp field
  final File? imageFile; // Add an optional image file field

  Message(this.senderName, this.text, this.timestamp, {this.imageFile});
}

class Communication_Admin extends StatefulWidget {
  Communication_Admin({required this.title});
  String title;
  @override
  _Communication_AdminState createState() => _Communication_AdminState();
}

class _Communication_AdminState extends State<Communication_Admin> {
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final ChatServices chatServices = ChatServices();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool isSendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loginData();
  }

  final String _userName = "Taniya";
  String? _selectedOption;
  String? _piorityOption;
  final ImagePicker _imagePicker = ImagePicker();
  Map<String, String> _usernameToIdMap = {};
  String? _selectedCleaner;
  String selectedUserId = '';
  String? token;
  String uesrId = '';
  String userType = "";
  String AdminuserId = "";

  List<Users> userList = [];
  List<String> _userTypeList = [];

  String imageUrl = '';
  String chatRoomId = "";

  final List<Message> _messages = [];
  void loginData() async {
    //Get logged user data
    Map<String, dynamic> userData = await AuthController.getLoginData();
    print(userData.toString());

    uesrId = await userData['id'];
    token = await userData['token'];
    userType = await userData['userType'];
    AdminuserId = await userData['Client siteId'];
    await getCleaners();

    print('userType ' + userType);
    print(token);
  }

  //create chat if there is no chat room created
//for first message
  void createChat() async {
    print('Inside Send Messages');
    if (_textController.text.isNotEmpty) {
      await chatServices
          .createChat(selectedUserId, _textController.text,
              _piorityOption ?? "", _selectedCleaner ?? "", widget.title,
              imageUrl: imageUrl)
          .then((value) {
        setState(() {
          chatRoomId = value;
          print(chatRoomId);
        });
        return '';
      });
      _textController.clear();
    }
  }

//send messages to the chat room created
//for messages except first message
  void sendMessages() async {
    print('Inside Send Messages');
    if (_textController.text.isNotEmpty || imageUrl.isNotEmpty) {
      await chatServices.sendMessages(chatRoomId, _textController.text,
          imageUrl: imageUrl);
      _textController.clear();
    }
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
                    print('chatRoomId ' + chatRoomId);
                    if (chatRoomId.isNotEmpty) {
                      sendMessages();
                    } else {
                      createChat();
                    }
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

  //build msg item
  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    // Ailgn messages to the right if the sender is the current user, otherwise to the left
    print(data['senderId'] + "........." + uesrId.toString());
    var isCurrentUser = (data['senderId'] == uesrId); //need to get login id
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.Hm().format(dateTime);
    var alignment;
    if (isCurrentUser) {
      alignment = Alignment.centerRight;
    } else {
      alignment = Alignment.centerLeft;
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blueGrey[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCurrentUser
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
                color: isCurrentUser ? Colors.black : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getCleaners() async {
    print("Getting cleaners list....");
    userList = [];
    print("token.................. ${token.toString()}");
    final response = await Dio().get("${BASE_API2}user/getAllCleanerUsers",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    var data = response.data['result'];
    print("DATA: $data");
    if (response.statusCode == 200) {
      final List<dynamic> usersData = response.data['result'];
      print("List: $usersData");

      final Map<String, String> usernameToIdMap = {};
      List<String> usernames = [];

      for (final user in usersData) {
        final String userId = user['user_id'].toString();
        final String username = user['f_name'].toString();
        final String userLastname = user['l_name'].toString();
        final String siteId = user['site_id'];

        // Check if user_id is equal to site_id
        if (AdminuserId == siteId) {
          print(userId);
          usernameToIdMap[username] = userId;
          usernames.add(username + " " + userLastname);
        }
      }

      // Remove duplicates
      usernames = usernames.toSet().toList();
      print(usernameToIdMap.toString());

      setState(() {
        _userTypeList = usernames;
        _usernameToIdMap = usernameToIdMap;
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CommunicationScreen()),
            (Route<dynamic> route) => false,
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "COMMUNICATION",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CommunicationScreen()));
                  Navigator.pop(context, true);
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
          body: Container(
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          elevation: 4, // Add elevation for shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16.0), // Add border radius
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                // Add a heading here
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: const EdgeInsets.all(10),
                                            child: const Text(
                                              "Admin",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 120),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 50,
                                                  right: 50,
                                                  bottom: 10),
                                              child: Text(
                                                widget
                                                    .title, // Change the text as needed
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Expanded(
                                  child: chatRoomId.isEmpty
                                      ? Container()
                                      : _buildMessageList(),
                                ),
                                const Divider(),
                                ListTile(
                                  // leading: const Icon(Icons.message,
                                  //     color: Color.fromARGB(255, 52, 137, 207)),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  8.0), // Optional padding
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10), // Optional border radius
                                            border: Border.all(
                                                color: Colors
                                                    .black), // Optional border
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(Icons.message,
                                                    color: Colors.black),
                                              ),
                                              Expanded(
                                                child: TextField(
                                                  controller: _textController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter what you need', // Include the selected emoji here
                                                    hintStyle:
                                                        TextStyle(fontSize: 15),
                                                    border: InputBorder.none,
                                                  ),
                                                  onChanged: (text) {
                                                    setState(() {
                                                      // Update isSendButtonEnabled based on whether the text field is empty or not
                                                      isSendButtonEnabled = text
                                                          .trim()
                                                          .isNotEmpty;
                                                    });
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.attachment,
                                                    color: Colors.black),
                                                onPressed: () {
                                                  _pickImageFromGallery();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      DropdownButton<String>(
                                        hint: Text('Select Employee'),
                                        value: _selectedCleaner,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedCleaner = newValue!;

                                            // Find the selected user's ID using the username-to-ID map
                                            selectedUserId =
                                                _usernameToIdMap[newValue] ??
                                                    '';
                                            print(
                                                "Selected User ID: $selectedUserId");
                                          });
                                        },
                                        items: [
                                          // DropdownMenuItem<String>(
                                          //   value: 'Select Cleaner',
                                          //   child: Text(
                                          //     'Select Cleaner',
                                          //     style: const TextStyle(
                                          //       fontFamily: "Open Sans",
                                          //       fontSize: 15,
                                          //     ),
                                          //   ),
                                          // ),
                                          for (var userName in _userTypeList)
                                            DropdownMenuItem<String>(
                                              value: userName,
                                              child: Text(
                                                userName,
                                                style: const TextStyle(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      IgnorePointer(
                                        ignoring:
                                            false, // Disable interaction with the second DropdownButton
                                        child: DropdownButton<String>(
                                          hint: Text('Select Piority Level'),
                                          value: _piorityOption,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _piorityOption = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'High',
                                            'Medium',
                                            'Low',
                                            // Add your dropdown options here
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 15,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      IgnorePointer(
                                        ignoring: _selectedCleaner == null ||
                                            _piorityOption == null,
                                        child: CircleAvatar(
                                          backgroundColor: _selectedCleaner ==
                                                      null ||
                                                  _piorityOption == null
                                              ? Colors
                                                  .grey // Use gray color when disabled
                                              : Colors
                                                  .black, // Use black color when enabled
                                          child: IconButton(
                                            icon: const Icon(Icons.send,
                                                color: Colors.white),
                                            onPressed: chatRoomId.isEmpty
                                                ? createChat
                                                : sendMessages,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Users {
  String fname,
      lname,
      email,
      id,
      start_date,
      end_date,
      doc,
      image,
      siteid,
      phone;
  String? allocationId;

  Users(
      {required this.fname,
      required this.lname,
      required this.email,
      required this.id,
      required this.start_date,
      required this.end_date,
      required this.phone,
      required this.doc,
      required this.image,
      required this.siteid,
      this.allocationId});
}
