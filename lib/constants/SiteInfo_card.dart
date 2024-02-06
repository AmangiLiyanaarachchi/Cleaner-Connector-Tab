import 'package:cleanconnectortab/constants/style.dart';
import 'package:flutter/material.dart';

class SiteInfoCardModel extends StatelessWidget {
  final String title;
  final String subtitle;
  final String rating;
  final String cookTime;
  final IconData customIcon;
  final String status;
  // final String thumbnailUrl;
  SiteInfoCardModel({
    required this.title,
    required this.subtitle,
    required this.cookTime,
    required this.rating,
    required this.customIcon,
    required this.status,
    // required this.thumbnailUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      width: MediaQuery.of(context).size.width / 5,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 3.0,
            spreadRadius: -6.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Icon(
              customIcon,
              color: kiconColor,
              size: 50,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: kiconColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
