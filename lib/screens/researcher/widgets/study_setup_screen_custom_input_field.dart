// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the custom input field that is provided on the study setup screen

import 'package:flutter/material.dart';

class StudySetupScreenCustomInputField extends StatelessWidget {
  const StudySetupScreenCustomInputField({
    Key key,
    @required this.headingTextStyle,
    @required this.compulsoryFieldIndicatorTextStyle,
    this.onTap,
    this.heading,
    this.subtitle,
  }) : super(key: key);

  final TextStyle headingTextStyle;
  final TextStyle compulsoryFieldIndicatorTextStyle;
  final Function onTap;
  final String heading;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: heading,
                  style: headingTextStyle,
                ),
                TextSpan(
                  text: ' *',
                  style: compulsoryFieldIndicatorTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(
                width: 0.75,
                color: Colors.grey[300],
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 10.0,
                ),
                child: subtitle ?? SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}