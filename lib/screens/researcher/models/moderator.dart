class Moderator {
  String uid;
  String email;
  String password;
  String phone;
  String userGroupName;

  Moderator({
    this.uid,
    this.email,
    this.password,
    this.phone,
    this.userGroupName,
  });

  Map<String, dynamic> toMap() {

    var moderatorMap = <String, dynamic>{};

    moderatorMap['uid'] = uid;
    moderatorMap['email'] = email;
    moderatorMap['password'] = password;
    moderatorMap['phone'] = phone;
    moderatorMap['userGroupName'] = userGroupName ?? 'Unassigned';

    return moderatorMap;
  }

  Moderator.fromMap(Map<String, dynamic> moderatorMap){
    uid = moderatorMap['uid'];
    email = moderatorMap['email'];
    password = moderatorMap['password'];
    phone = moderatorMap['phone'];
    userGroupName = moderatorMap['userGroupName'];

  }
}
