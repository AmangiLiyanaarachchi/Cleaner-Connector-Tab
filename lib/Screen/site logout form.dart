import 'dart:async';

import 'package:cleanconnectortab/AdminLogin.dart';
import 'package:cleanconnectortab/Controller/authController.dart';
import 'package:cleanconnectortab/Dashboard.dart';
import 'package:cleanconnectortab/Screen/splash_screen.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../CleanerLogin.dart';

String? finalusername;
String? finalpassword;

class SiteLogoutScreen extends StatefulWidget {
  const SiteLogoutScreen({Key? key}) : super(key: key);

  @override
  _SiteLogoutScreenState createState() => _SiteLogoutScreenState();
}

class _SiteLogoutScreenState extends State<SiteLogoutScreen> {
  static const _colors = [
    Color(0x4A40BCFE),
    Color(0xFF00BBF9),
    Color(0x8B0032F9),
  ];

  static const _durations = [6000, 5000, 4000];

  static const _heightPercentages = [0.95, 0.86, 0.75];
  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearSharedPreferences();
  }

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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SizedBox(
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

  Future LogoutData() async {
    //final prefs = await SharedPreferences.getInstance();
    print('username-$email\npassword-$password');
    setState(() {
      isLoading = true;
      typing = false;
    });
    try {
      print("xxxx");
      
      var response = await Dio().post('${BASE_API2}user/login', data: {
        "email": email,
        "password": password,
      });
      res = response.data["message"];
      print("!!!!!!!!!!$response");
      print(response.data["token"]);
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        if (response.data["message"] == "Client loging success") {
          final prefs = await SharedPreferences.getInstance();
          prefs.clear();
          setState(() {
            loginSiteData['email'] = '';
            loginSiteData['password'] = '';
            loginSiteData['userType'] = '';
            loginSiteData['accessToken'] = '';
            loginSiteData['id'] = '';
            loginUserProfile['id'] = '';
            loginUserProfile['name'] = '';
            loginUserProfile['phone'] = '';
            loginUserProfile['email'] = '';
            loginUserProfile['site_name'] = '';
            loginUserProfile['rate'] = '';
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          emailEditingController.clear();
          passwordEditingController.clear();
         print("site mail"   + loginSiteData['email']);
          print("site mail"   + loginCleanerData['email']);
          print("site mail"   + loginUserProfile['email']);
          print("site mail"   + loginUserData['email']);
        }
         else {
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
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("Bad Error");
        print(e.response?.data["message"]);
        if (e.response?.data["message"]  == "Client password not valid") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Invalid password.'),
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
        else {
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
                            color: Colors.black,
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
                          "LOGOUT",
                          style: TextStyle(color: kiconColor, fontSize: 20),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && emailEditingController.text.toLowerCase() == loginSiteData['email'].toLowerCase()) {
                            _formKey.currentState!.save();
                            await LogoutData();
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("This email does not have access to site logout."),
                                duration: const Duration(milliseconds: 1500),
                              ),
                            );
                            Timer(
                                const Duration(milliseconds: 1600),
                                    () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard())));
                          }
                        },
                      ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Icon(Icons.play_circle, color: Color(0xffaeddf8),),
            //     TextButton(
            //       onPressed: () {
            //         Get.closeAllSnackbars();
            //         // Timer(const Duration(milliseconds: 1500), () =>Navigator.push(
            //         //     context,
            //         //     MaterialPageRoute(
            //         //         builder: (context) => const Signup_Screen())));
            //         // image = null;
            //       },
            //       child: const Text(
            //         "SIGN UP",
            //         style: TextStyle(
            //             color: Color(0xff5086c2),
            //             fontSize: 20),
            //       ),
            //
            //     ),
            //   ],
            // ),
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
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom))
          ],
        ),
      ),
    );
  }
}
