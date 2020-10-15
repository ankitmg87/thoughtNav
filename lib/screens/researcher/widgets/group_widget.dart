import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';

class GroupWidget extends StatefulWidget {
  final TextEditingController groupNameController;
  final TextEditingController internalGroupLabelController;
  final Group group;
  final List<Group> groups;
  final Function groupNameValidator;
  final Function internalGroupLabelValidator;

  const GroupWidget({
    Key key,
    this.groupNameController,
    this.internalGroupLabelController,
    this.group,
    this.groups,
    this.groupNameValidator,
    this.internalGroupLabelValidator,
  }) : super(key: key);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.groupNameController,
            validator: widget.groupNameValidator,
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
            controller: widget.internalGroupLabelController,
            validator: widget.internalGroupLabelValidator,
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
