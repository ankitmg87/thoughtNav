import 'package:flutter/cupertino.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';

class Group {
  String groupUID;
  int groupIndex;
  String groupName;
  String internalGroupLabel;

  Group({
    this.groupUID,
    this.groupIndex,
    this.groupName,
    this.internalGroupLabel,

  });

  Map<String, dynamic> toMap () {
    var group = <String, dynamic> {};

    group['groupUID'] = groupUID;
    group['groupIndex'] = groupIndex;
    group['groupName'] = groupName;
    group['internalGroupLabel'] = internalGroupLabel;

    return group;
  }

  Group.fromMap(Map<String, dynamic> group){
    groupUID = group['groupUID'];
    groupIndex = group['groupIndex'];
    groupName = group['groupName'];
    internalGroupLabel = group['internalGroupLabel'];
  }

}
