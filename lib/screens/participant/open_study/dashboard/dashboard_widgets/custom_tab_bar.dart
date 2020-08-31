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