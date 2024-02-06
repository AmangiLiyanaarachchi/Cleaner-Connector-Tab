import 'dart:io';

import 'package:cleanconnectortab/CleanerLogin.dart';
import 'package:cleanconnectortab/Communication.dart';
import 'package:cleanconnectortab/Models/push_notification.dart';
import 'package:cleanconnectortab/Screen/notificationScreen.dart';
import 'package:cleanconnectortab/Screen/splash_screen.dart';
import 'package:cleanconnectortab/SiteInfo.dart';
import 'package:cleanconnectortab/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Dashboard.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: Platform.isAndroid
          ? FirebaseOptions(
              apiKey: 'AIzaSyA7p2rShiMEe_nKhjYbtT9QIkegV10sB3M',
              appId: '1:33588551520:android:c93cd1ba8e0ed5a503c805',
              messagingSenderId: '33588551520',
              projectId: 'cleanerconnect-b06a3',
              storageBucket: "cleanerconnect-b06a3.appspot.com",
            )
          : null);
  await FirebaseAPI().initNotifications();

  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: SplashScreen(),
      routes: {
        NotificationScreen.route: (context) => NotificationScreen()
      },
    );
  }
}
