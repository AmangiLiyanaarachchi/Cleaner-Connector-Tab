import 'package:cleanconnectortab/Dashboard.dart';
import 'package:cleanconnectortab/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/style.dart';

class logoutButton extends StatefulWidget {
  const logoutButton({Key? key}) : super(key: key);

  @override
  State<logoutButton> createState() => _logoutButtonState();
}

class _logoutButtonState extends State<logoutButton> {
  static logOut(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      // the new route
      MaterialPageRoute(
        builder: (BuildContext context) => Dashboard(),
      ),

      // this function should return true when we're done removing routes
      // but because we want to remove all other screens, we make it
      // always return false
      (Route route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: GestureDetector(
        onTap: () async {
          _onBackButtonPressed(context);
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
                    style: TextStyle(
                      fontSize: 16,
                      color: kiconColor
                    ),
                  )),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      logOut(context);
                    });
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 16,
                      color: kiconColor
                    ),
                  )),
            ],
          );
        });
    return exitApp ?? false;
  }
}
