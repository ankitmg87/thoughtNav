// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the Dropdown menu that is shown to the participants if they
/// are using a desktop configuration

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class DesktopDropdownMenuOptionsRow extends StatelessWidget {
  const DesktopDropdownMenuOptionsRow({
    Key key,
    this.image1,
    this.image2,
    this.label1,
    this.label2,
    this.onTap1,
    this.onTap2,
  }) : super(key: key);

  final String image1;
  final String image2;
  final String label1;
  final String label2;
  final Function onTap1;
  final Function onTap2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap1,
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            width: 200.0,
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
            child: Row(
              children: [
                Image(
                  width: 20.0,
                  image: AssetImage(
                    image1,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  label1,
                  style: TextStyle(
                    color: TEXT_COLOR,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap2 ?? () {},
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            width: 200.0,
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
            child: Row(
              children: [
                image2 == null
                    ? SizedBox()
                    : Image(
                  width: 20.0,
                  image: AssetImage(
                    image2,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                label2 == null
                    ? SizedBox()
                    : Text(
                  label2,
                  style: TextStyle(
                    color: TEXT_COLOR,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}