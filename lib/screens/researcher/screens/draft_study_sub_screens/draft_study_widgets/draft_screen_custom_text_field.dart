// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines a custom text field

import 'package:flutter/material.dart';

class DraftScreenCustomTextField extends StatelessWidget {
  final Widget child;
  final TextFormField textFormField;

  const DraftScreenCustomTextField(
      {Key key, @required this.child, this.textFormField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          SizedBox(
            height: 10.0,
          ),
          textFormField,
        ],
      ),
    );
  }
}