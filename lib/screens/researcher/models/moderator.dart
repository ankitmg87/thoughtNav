class Moderator {
  String moderatorAvatar;
  String moderatorUID;
  String email;
  String firstName;
  String lastName;
  String password;
  String phone;
  List<dynamic> assignedStudies;

  Moderator({
    this.moderatorAvatar,
    this.moderatorUID,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.phone,
    this.assignedStudies,
  });

  Map<String, dynamic> toMap() {

    var moderatorMap = <String, dynamic>{};

    moderatorMap['moderatorAvatar'] = moderatorAvatar;
    moderatorMap['moderatorUID'] = moderatorUID;
    moderatorMap['email'] = email;
    moderatorMap['firstName'] = firstName;
    moderatorMap['lastName'] = lastName;
    moderatorMap['password'] = password;
    moderatorMap['phone'] = phone;
    moderatorMap['assignedStudies'] = assignedStudies;

    return moderatorMap;
  }

  Moderator.fromMap(Map<String, dynamic> moderatorMap){
    moderatorAvatar = moderatorMap['moderatorAvatar'];
    moderatorUID = moderatorMap['moderatorUID'];
    email = moderatorMap['email'];
    firstName = moderatorMap['firstName'];
    lastName = moderatorMap['lastName'];
    password = moderatorMap['password'];
    phone = moderatorMap['phone'];
    assignedStudies = moderatorMap['assignedStudies'];

  }
}
