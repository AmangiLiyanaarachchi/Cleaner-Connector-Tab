import 'package:cleanconnectortab/Screen/help_screen.dart';
import 'package:cleanconnectortab/communication_admin.dart';
import 'package:cleanconnectortab/communication_cleaner.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class Message {
  final String senderName;
  final String text;
  final DateTime timestamp; // Add a timestamp field

  Message(this.senderName, this.text, this.timestamp);
}

class HelpData extends StatefulWidget {
  HelpData({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.module,
  });

  final String title;
  final String description;
  final String videoUrl;
  final String module;

  @override
  _HelpDataState createState() => _HelpDataState();
}

class _HelpDataState extends State<HelpData> {
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  // String url = "https://firebasestorage.googleapis.com/v0/b/qr-api-be.appspot.com/o/videos%2Fvideo%203.mp4_Sat%20Nov%2011%202023%2007%3A24%3A31%20GMT%2B0000%20(Coordinated%20Universal%20Time)?alt=media&token=bd26ae3f-e109-4cb2-9f1b-2e485bf9127e";

  @override
  void initState() {
    super.initState();

    // Initialize video player controller
    VideoPlayerController _videoPlayerController =
      VideoPlayerController.networkUrl(
    Uri.parse(widget.videoUrl), // Use widget.videoUrl here
  );

    // Initialize chewie controller with custom aspect ratio
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  final String _userName = "Taniya";
  String _selectedOption = 'Select Cleaner';

  final List<Message> _messages = [
    Message("Cleaner 2", "Completed Task", DateTime.now()),
    Message("Cleaner 1", "Completed Task", DateTime.now()),
    Message("Admin", "Need to dust 1st floor", DateTime.now()),
  ];

  void _handleSubmitted(String text) {
    final message = Message(_userName, text, DateTime.now()); // Add a timestamp

    setState(() {
      _messages.insert(0, message);
    });
    _textController.clear(); // Clear the input field
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double videoHeight = screenHeight * 0.4;
    double videoWidth = screenWidth * 0.7;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.title.toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: kiconColor),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HelpScreen(
                    module: widget.module,
                  )));
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    height: videoHeight,
                    width: videoWidth,
                    child: Chewie(controller: _chewieController),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
