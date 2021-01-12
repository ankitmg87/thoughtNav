
class Group {
  String groupUID;
  int groupIndex;
  String groupName;
  String internalGroupLabel;
  String groupRewardAmount;

  Group({
    this.groupUID,
    this.groupIndex,
    this.groupName,
    this.internalGroupLabel,
    this.groupRewardAmount,
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
