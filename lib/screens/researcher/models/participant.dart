class Participant {
  String participantUID;
  String alias;
  String userName;
  String userGroupName;
  String lastSeen;
  String email;
  String phone;
  String password;
  String age;
  String gender;
  String responses;
  String comments;
  String groupUID;

  bool isActive;
  bool isDeleted;

  Participant({
    this.participantUID,
    this.alias,
    this.userName,
    this.userGroupName,
    this.lastSeen,
    this.email,
    this.phone,
    this.password,
    this.age,
    this.gender,
    this.responses,
    this.comments,
    this.isActive,
    this.isDeleted,
    this.groupUID,
  });

  Map<String, dynamic> toMap() {
    var participant = <String, dynamic>{};

    participant['participantUID'] = participantUID;
    participant['alias'] = alias;
    participant['userName'] = userName;
    participant['userGroupName'] = userGroupName;
    participant['lastSeen'] = lastSeen;
    participant['email'] = email;
    participant['phone'] = phone;
    participant['password'] = password;
    participant['age'] = age;
    participant['gender'] = gender;
    participant['responses'] = responses;
    participant['comments'] = comments;
    participant['isActive'] = isActive;
    participant['isDeleted'] = isDeleted;

    return participant;
  }

  Participant.fromMap(Map<String, dynamic> participant){
    participantUID = participant['participantUID'];
    alias = participant['alias'];
    userName = participant['userName'];
    userGroupName = participant['userGroupName'];
    lastSeen = participant['lastSeen'];
    email = participant['email'];
    phone = participant['phone'];
    password = participant['password'];
    age = participant['age'];
    gender = participant['gender'];
    responses = participant['responses'];
    comments = participant['comments'];
    isActive = participant['isActive'];
    isDeleted = participant['isDeleted'];
  }
}
