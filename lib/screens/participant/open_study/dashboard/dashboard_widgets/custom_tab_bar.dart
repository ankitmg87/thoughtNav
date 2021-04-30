// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';

import 'custom_tab.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTab(),
        CustomTab(),
        CustomTab(),
      ],
    );
  }
}