// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the User model

class User {
  String userUID;
  String userType;
  String studyUID;
  String userEmail;
  String userPassword;

  User({
    this.userUID,
    this.userType,
    this.studyUID,
    this.userEmail,
    this.userPassword,
  });

  Map<String, dynamic> toMap() {
    var user = <String, dynamic>{};

    user['userUID'] = userUID;
    user['userType'] = userType;
    user['studyUID'] = studyUID;
    user['userEmail'] = userEmail;
    user['userPassword'] = userPassword;

    return user;
  }

  User.fromMap(Map<String, dynamic> user) {
    userType = user['userType'];
    studyUID = user['studyUID'];
    userEmail = user['userEmail'];
    userPassword = user['userPassword'];
  }
}
