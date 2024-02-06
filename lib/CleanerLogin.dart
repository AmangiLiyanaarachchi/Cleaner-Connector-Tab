import 'dart:async';
import 'dart:io';

import 'package:cleanconnectortab/Dashboard.dart';
import 'package:cleanconnectortab/Screen/splash_screen.dart';
import 'package:cleanconnectortab/Timer.dart';
import 'package:cleanconnectortab/constants/const_api.dart';
import 'package:cleanconnectortab/constants/style.dart';
import 'package:cleanconnectortab/login.dart';
import 'package:cleanconnectortab/services/api_services.dart';
// import 'package:cleanerconnectapp/Dashboard.dart';
// import 'package:cleanerconnectapp/const_api.dart';
// import 'package:cleanerconnectapp/splash_screen.dart';
// import 'package:cleanerconnectapp/style.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

String? finalusername;
String? finalpassword;

class CleanerLoginScreen extends StatefulWidget {
  const CleanerLoginScreen({Key? key}) : super(key: key);

  @override
  _CleanerLoginScreenState createState() => _CleanerLoginScreenState();
}

class _CleanerLoginScreenState extends State<CleanerLoginScreen> {
  static const _colors = [
    Color(0x4A40BCFE),
    Color(0xFF00BBF9),
    Color(0x8B0032F9),
  ];

  static const _durations = [6000, 5000, 4000];

  static const _heightPercentages = [0.95, 0.86, 0.75];

  @override
  Widget build(BuildContext context) {
    final Sizes = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }},
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/base_logo.png',
                    ),
                    color: kiconColor,
                    height: 180,
                    width: 200,
                  ),
                  Center(child: LoginForm()),
                  Row(
                    children: [
                      WaveWidget(
                        config: CustomConfig(
                          colors: _colors,
                          durations: _durations,
                          heightPercentages: _heightPercentages,
                        ),
                        // backgroundColor: _backgroundColor,
                        size: Size(width, height * 0.1),
                        waveAmplitude: 3,
                      ),
                    ],
                  ),
                  // Spacer(
                  //   flex: 1,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

Map<String, dynamic> loginCleanerData = {
  'id': '',
  'admin_name': '',
  'email': '',
  'accessToken': '',
  'userType': '',
  'adminType': '',
  'password': '',
  'userId': '',
  'Start_time' : '',
  'isStart' : '',
  'record_id': ''
};

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isObscure = true;
  bool isLoading = false;
  bool typing = true;
  String res = '';

  final ImagePicker _picker = ImagePicker();
  File? capturedImageFile;
  Future<void> captureImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      capturedImageFile = File(pickedImage.path);
      // Handle the captured image here (e.g., upload it to a server or display it).
      // You can use the pickedImage.path to get the file path of the captured image.
      // For example:
      // final File capturedImageFile = File(pickedImage.path);
      // ... perform actions with the captured image ...
    }
  }

  Future LoginData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String siteId =
        await sharedPreferences.getString('Client siteId').toString();
    print(siteId);
    print('username-$email\npassword-$password');
    setState(() {
      isLoading = true;
      typing = false;
    });
    try {
      // Capture Image
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        capturedImageFile = File(pickedImage.path);
        print(capturedImageFile.toString());
      }

      print('username-$email\npassword-$password');
      print(loginSiteData['id']);

      // Create FormData
      var formData = FormData.fromMap({
        "email": email,
        "password": password,
        "site_id": siteId,
        "image": await MultipartFile.fromFile(capturedImageFile!.path,
            filename: "image.jpg"),
      });
print("1");
      var response =
          await Dio().post('${BASE_API2}user/tab-login/${loginSiteData['id']}', data: FormData.fromMap({
            "email": email,
            "password": password,
            "site_id": siteId,
            "image": await MultipartFile.fromFile(capturedImageFile!.path,
                filename: "image.jpg"),
          }));
      print(response.data);
print("2");
      res = response.data["message"];
      print("!!!!!!!!!!$response");
      print(response.data["token"]);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        final Map<String, dynamic> data = response.data;

        if (data["message"] == "record need to end" ||
            data["message"] == "record created successfully and need to start" ||
            data["message"] == "record from another site and need to end"
        ) {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setBool(SplashScreenState.KEYLOGIN, true);
          await sharedPreferences.setString(
              'username', emailEditingController.text);
          await sharedPreferences.setString(
              'password', passwordEditingController.text);

          await sharedPreferences.setString('token', response.data['token']);
          await sharedPreferences.setString('id', response.data['user_id']);
          await sharedPreferences.setString('userType', 'cleaner');
          await sharedPreferences.setString('email', emailEditingController.text);
          await sharedPreferences.setBool('login', true);

          setState(() {
            loginStatus = true;
            loginCleanerData['email'] = emailEditingController.text;
            loginCleanerData['password'] = passwordEditingController.text;
            loginCleanerData['accessToken'] = response.data['token'];
            loginCleanerData['id'] = response.data['user_id'];
            loginCleanerData['userType'] = 'cleaner';
            loginCleanerData['record_id'] = response.data['record_id'];
            loginCleanerData['isStart'] = (response.data["message"] == "record need to end")
                  ? "true"
            :(response.data["message"] == "record from another site and need to end")
                ? "logged"
                : "false";
            if(data["message"] == "record need to end"){
              loginCleanerData['Start_time'] = response.data['start_time'];
            }
            print(response.data["message"]);
            print(loginCleanerData['isStart']);
            print(loginCleanerData['Start_time']);
          });

          //get username
          await ApiServices.getLoggedUserDetails(
                  loginCleanerData['id'], loginCleanerData['accessToken'])
              .then(
            (value) async {
              await sharedPreferences.setString('fname', value['fname']);
              await sharedPreferences.setString('lname', value['lname']);
              await sharedPreferences.setString('siteId', value['siteId']);
              return;
            },
          );
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TimerScreen()));
          emailEditingController.clear();
          passwordEditingController.clear();
        } else if (response.data["message"] ==
            "Cleaner Password is incorrect") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Invalid password"),
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
        } else if (response.data["message"] == "Cleaner Email is incorrect") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Invalid Email'),
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Something went wrong.Please try again'),
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
      } else if (response.statusCode == 400) {
        print("Bad error.....................");
      } else {
        print(response.statusCode);
        setState(() {
          isLoading = false;
        });
        if (response.data["message"] == "Cleaner Email is incorrect") {
          print("User entered wrong password");
        }
      }
      print("@Error");
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        setState(() {
          isLoading = false;
          typing = true;
        });
        print("Bad Error");
        print(e.response);
        if (e.response?.data["message"] == "Cannot read properties of undefined (reading 'Monday')") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You have not allowed to log into this site."),
            ),
          );
        }
        if (e.response?.data["message"] == "ER_EMPTY_QUERY: Query was empty") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You have not allowed to log into this site."),
            ),
          );
          setState(() {
            emailEditingController.clear();
            passwordEditingController.clear();
          });
        }
        if (e.response?.data["message"] == "User email not exist") {
        } else if (e.response?.data["message"] ==
            "No any registered user for this email") {}
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong. Please contact admin."),
          ),
        );
        setState(() {
          emailEditingController.clear();
          passwordEditingController.clear();
          isLoading = false;
          typing = true;
        });
      }
      print(e.toString());
      setState(() {
        isLoading = false;
        typing = true;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.email,
                    color: kiconColor,
                  ),
                  // const SizedBox(width: 50,),
                  Container(
                    // padding: EdgeInsets.only(top: 20, bottom: 20),
                    alignment: Alignment.center,
                    width: width * 0.70,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          )
                        ],
                        color: const Color.fromRGBO(241, 239, 239, 0.298),
                        border: Border.all(width: 0, color: Colors.white),
                        borderRadius: BorderRadius.circular(11)),
                    // width: width,
                    child: TextFormField(
                      controller: emailEditingController,
                      enabled: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 30, 15, 0),
                        hintText: "Email",
                        hintStyle: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (email) {
                        if (EmailValidator.validate(email!)) {
                          return null;
                        }
                        if (email != null && email.isEmpty) {
                          return "Email can't be empty";
                        } else {
                          return "Please enter a valid email";
                        }
                      },
                      onChanged: (String? text) {
                        email = text!;
                        // print(email);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.password,
                    color: kiconColor,
                  ),
                  // const SizedBox(width: 50,),
                  Container(
                    alignment: Alignment.center,
                    width: width * 0.70,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                        color: const Color.fromRGBO(241, 239, 239, 0.298),
                        border: Border.all(width: 0, color: Colors.white),
                        borderRadius: BorderRadius.circular(11)),
                    // width: width * 0.,
                    child: TextFormField(
                      controller: passwordEditingController,
                      obscureText: _isObscure,
                      enabled: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                            icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 30, 15, 0),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (String? Password) {
                        if (Password != null && Password.isEmpty) {
                          return "Password can't be empty";
                        } else if (res == "Cleaner Password is incorrect") {
                          return "Password is Invalid";
                        }
                        return null;
                      },
                      onChanged: (String? text) {
                        password = text!;
                        // print(email);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text(
                      "",
                      style: TextStyle(color: kiconColor, fontSize: 14),
                    ),
                    onPressed: () {
                      // Timer(
                      //     const Duration(milliseconds: 1500),
                      //     () => Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 const ForgotPasswordScreen())));
                    },
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle,
                  color: kiconColor,
                ),
                isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: SpinKitDualRing(
                          color: kiconColor,
                          size: 30,
                        ),
                      )
                    : TextButton(
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: kiconColor, fontSize: 20),
                        ),
                        onPressed: ()  {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Capture the image before navigating to the Dashboard.
                            // await captureImage();
                             LoginData();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => TimerScreen()));
                          }
                        },
                      ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            const Padding(
              // SizedBox(height: 130,)
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "By clicking Login, you agree to our privacy policy & terms of service.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
          ],
        ),
      ),
    );
  }
}
