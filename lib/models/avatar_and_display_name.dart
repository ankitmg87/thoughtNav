// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the AvatarAndDisplayName model

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
