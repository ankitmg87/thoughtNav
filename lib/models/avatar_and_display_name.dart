// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

class AvatarAndDisplayName {
  String id;
  String avatarURL;
  String displayName;
  bool selected;

  AvatarAndDisplayName({
    this.id,
    this.avatarURL,
    this.displayName,
    this.selected,
  });

  Map<String, dynamic> toMap() {
    var avatarAndDisplayNameMap = <String, dynamic>{};

    avatarAndDisplayNameMap['id'] = id;
    avatarAndDisplayNameMap['avatarURL'] = avatarURL;
    avatarAndDisplayNameMap['displayName'] = displayName;
    avatarAndDisplayNameMap['selected'] = selected;

    return avatarAndDisplayNameMap;
  }

  AvatarAndDisplayName.fromMap(
    Map<String, dynamic> avatarAndDisplayNameMap,
  ) {
    id = avatarAndDisplayNameMap['id'];
    avatarURL = avatarAndDisplayNameMap['avatarURL'];
    displayName = avatarAndDisplayNameMap['displayName'];
    selected = avatarAndDisplayNameMap['selected'];
  }
}
