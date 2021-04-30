// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:thoughtnav/screens/researcher/models/participant.dart';

class Group {
  String groupUID;
  int groupIndex;
  String groupName;
  String internalGroupLabel;
  String groupRewardAmount;
  List<Participant> participants;

  Group({
    this.groupUID,
    this.groupIndex,
    this.groupName,
    this.internalGroupLabel,
    this.groupRewardAmount,
    this.participants,
  });

  Map<String, dynamic> toMap () {
    var group = <String, dynamic> {};

    group['groupUID'] = groupUID;
    group['groupIndex'] = groupIndex;
    group['groupName'] = groupName;
    group['internalGroupLabel'] = internalGroupLabel;
    group['groupRewardAmount'] = groupRewardAmount;

    return group;
  }

  Group.fromMap(Map<String, dynamic> group){
    groupUID = group['groupUID'];
    groupIndex = group['groupIndex'];
    groupName = group['groupName'];
    internalGroupLabel = group['internalGroupLabel'];
    groupRewardAmount = group['groupRewardAmount'];
  }

}
