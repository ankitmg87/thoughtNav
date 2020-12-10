class Moderator {
  String id;
  String moderatorUID;
  String email;
  String password;
  String phone;
  String userGroupName;
  bool isOnboarded;

  Moderator({
    this.id,
    this.moderatorUID,
    this.email,
    this.password,
    this.phone,
    this.userGroupName,
    this.isOnboarded,
  });

  Map<String, dynamic> toMap() {

    var moderatorMap = <String, dynamic>{};

    moderatorMap['id'] = id;
    moderatorMap['moderatorUID'] = moderatorUID;
    moderatorMap['email'] = email;
    moderatorMap['password'] = password;
    moderatorMap['phone'] = phone;
    moderatorMap['userGroupName'] = userGroupName ?? 'Unassigned';
    moderatorMap['isOnboarded'] = isOnboarded;

    return moderatorMap;
  }

  Moderator.fromMap(Map<String, dynamic> moderatorMap){
    id = moderatorMap['id'];
    moderatorUID = moderatorMap['moderatorUID'];
    email = moderatorMap['email'];
    password = moderatorMap['password'];
    phone = moderatorMap['phone'];
    userGroupName = moderatorMap['userGroupName'];
    isOnboarded = moderatorMap['isOnboarded'];

  }
}
