// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class DraftScreenGroupWidget extends StatefulWidget {
  final String studyUID;
  final Group group;
  final TextEditingController groupNameController;
  final TextEditingController groupRewardController;

  const DraftScreenGroupWidget({
    Key key,
    this.studyUID,
    this.group,
    this.groupNameController,
    this.groupRewardController,
  }) : super(key: key);

  @override
  _DraftScreenGroupWidgetState createState() => _DraftScreenGroupWidgetState();
}

class _DraftScreenGroupWidgetState extends State<DraftScreenGroupWidget> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  final FocusNode _groupNameFocusNode = FocusNode();
  final FocusNode _internalGroupLabelFocusNode = FocusNode();
  final FocusNode _groupRewardAmountFocusNode = FocusNode();

  final _rewardAmountFormatter = MaskTextInputFormatter(
      mask: '##########', filter: {'#': RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    _groupNameFocusNode.addListener(() {
      if (!_groupNameFocusNode.hasFocus) {
        if (widget.group.groupName.isNotEmpty ||
            widget.group.groupName != null) {
          _updateGroupDetails();
        }
      }
    });
    _internalGroupLabelFocusNode.addListener(() {
      if (!_internalGroupLabelFocusNode.hasFocus) {
        if (widget.group.internalGroupLabel.isNotEmpty ||
            widget.group.groupName != null) {
          _updateGroupDetails();
        }
      }
    });
    _groupRewardAmountFocusNode.addListener(() {
      if(!_groupRewardAmountFocusNode.hasFocus){
        if(widget.group.groupRewardAmount != null){
          _updateGroupDetails();
        }
      }
    });
  }

  void _updateGroupDetails() async {
    await _researcherAndModeratorFirestoreService.updateGroup(
        widget.studyUID, widget.group);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${widget.group.groupIndex}.',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: TextFormField(
            focusNode: _groupNameFocusNode,
            controller: widget.groupNameController,
            onChanged: (groupName) {
              widget.group.groupName = groupName;
            },
            onFieldSubmitted: (groupName) {
              if (groupName != null || groupName.isNotEmpty) {
                _updateGroupDetails();
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter Group Name',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(
                  color: Colors.grey[400],
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 40.0,
        ),
        Expanded(
          child: TextFormField(
            focusNode: _internalGroupLabelFocusNode,
            initialValue: widget.group.internalGroupLabel,
            onChanged: (internalGroupLabel) {
              widget.group.internalGroupLabel = internalGroupLabel;
            },
            onFieldSubmitted: (internalGroupLabel) {
              if (internalGroupLabel != null || internalGroupLabel.isNotEmpty) {
                _updateGroupDetails();
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter Internal Group Label',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(
                  color: Colors.grey[400],
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 40.0,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300],
                width: 1.0,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextFormField(
                    focusNode: _groupRewardAmountFocusNode,
                    controller: widget.groupRewardController,
                    onChanged: (groupReward) {
                      widget.group.groupRewardAmount = groupReward;
                    },
                    onFieldSubmitted: (groupReward) {
                      if (groupReward != null || groupReward.isNotEmpty) {
                        _updateGroupDetails();
                      }
                    },
                    inputFormatters: [
                      _rewardAmountFormatter,
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter Group Reward Amount',
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
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
