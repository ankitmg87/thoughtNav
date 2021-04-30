// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key key,
    this.image,
    this.title,
    this.width,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final double width;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(
        width: width ?? 20.0,
        image: AssetImage(
          image,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onTap: onTap ?? () {},
    );
  }
}
