import 'dart:ui';

import 'package:cleanconnectortab/constants/style.dart';
import 'package:flutter/material.dart';

class DashboardCardModel extends StatelessWidget {
  final String title;
  final String subtitle;
  final String rating;
  final String cookTime;
  final IconData customIcon;
  final String status;
  final String thumbnailUrl;
  // final String thumbnailUrl;
  DashboardCardModel({
    required this.title,
    required this.subtitle,
    required this.cookTime,
    required this.rating,
    required this.customIcon,
    required this.status,
    required this.thumbnailUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          width: MediaQuery.of(context).size.width * 0.5,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: AssetImage(thumbnailUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                decoration: BoxDecoration(
                  color: kiconColor.withOpacity(0.8),
                  borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  // border: Border.all(
                  //   color: Colors.white,
                  //   width: 2
                  // ),// Add rounded corners
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Change the color to your desired color
                    ),
                  ),
                ),
              ),
            ),
          ),

        )
      ],
    );
  }
}
