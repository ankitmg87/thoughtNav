// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

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