// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the container which carries various information that is
/// shown to participants on the onboarding screens

import 'package:flutter/material.dart';

class CustomInformationContainer extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final double width;

  const CustomInformationContainer({
    Key key,
    this.title,
    this.subtitle1,
    this.subtitle2, this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      constraints: BoxConstraints(
        maxWidth: 600.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              subtitle1,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16.0,
                height: 1.25,
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          subtitle2 == null ? SizedBox() :
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              subtitle2,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16.0,
                height: 1.25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
