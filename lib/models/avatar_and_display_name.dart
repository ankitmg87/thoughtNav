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
    var avatarAndDisplayNameMap = {};

    avatarAndDisplayNameMap['id'] = id;
    avatarAndDisplayNameMap['avatarURL'] = avatarURL;
    avatarAndDisplayNameMap['displayName'] = displayName;
    avatarAndDisplayNameMap['selected'] = selected;

    return avatarAndDisplayNameMap;
  }

  AvatarAndDisplayName.fromMap(Map<String, dynamic> avatarAndDisplayNameMap,){
    id = avatarAndDisplayNameMap['id'];
    avatarURL = avatarAndDisplayNameMap['avatarURL'];
    displayName = avatarAndDisplayNameMap['displayName'];
    selected = avatarAndDisplayNameMap['selected'];
  }

}
