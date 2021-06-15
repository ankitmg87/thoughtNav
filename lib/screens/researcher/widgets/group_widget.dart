// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';

class GroupWidget extends StatefulWidget {
  final List<Map<String, dynamic>> groups;
  final int index;

  const GroupWidget({
    Key key,
    this.groups,
    this.index,
  }) : super(key: key);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final Group group = Group();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please set a group name';
              } else {
                group.groupName = value;
                if (group.groupName.isNotEmpty &&
                    group.internalGroupLabel.isNotEmpty) {
                  widget.groups.add(group.toMap());
                }
                return null;
              }
            },
            cursorColor: PROJECT_NAVY_BLUE,
            decoration: InputDecoration(
              hintText: 'Group Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please set an internal group label';
              } else {
                if (group.groupName.isNotEmpty &&
                    group.internalGroupLabel.isNotEmpty) {
                  widget.groups.add(group.toMap());
                }
                return null;
              }
            },
            cursorColor: PROJECT_NAVY_BLUE,
            decoration: InputDecoration(
              hintText: 'Internal Group Label',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
