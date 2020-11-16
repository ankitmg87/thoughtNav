class Moderator {
  String id;
  String uid;
  String email;
  String password;
  String phone;
  String userGroupName;

  Moderator({
    this.id,
    this.uid,
    this.email,
    this.password,
    this.phone,
    this.userGroupName,
  });

  Map<String, dynamic> toMap() {

    var moderatorMap = <String, dynamic>{};

    moderatorMap['id'] = id;
    moderatorMap['uid'] = uid;
    moderatorMap['email'] = email;
    moderatorMap['password'] = password;
    moderatorMap['phone'] = phone;
    moderatorMap['userGroupName'] = userGroupName ?? 'Unassigned';

    return moderatorMap;
  }

  Moderator.fromMap(Map<String, dynamic> moderatorMap){
    id = moderatorMap['id'];
    uid = moderatorMap['uid'];
    email = moderatorMap['email'];
    password = moderatorMap['password'];
    phone = moderatorMap['phone'];
    userGroupName = moderatorMap['userGroupName'];

  }
}
