// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the participant model

import 'package:flutter/cupertino.dart';

class Participant {
  String participantUID;
  String displayName;
  String userFirstName;
  String userLastName;
  String userGroupName;
  String lastSeen;
  String email;
  String phone;
  String password;
  String gender;
  int responses;
  int comments;
  String paymentMode;
  String groupUID;
  String profilePhotoURL;
  String rewardAmount;
  String secondaryEmail;

  bool isActive;
  bool isDeleted;
  bool isOnboarded;

  Participant({
    this.participantUID,
    this.displayName,
    this.userFirstName,
    this.userLastName,
    this.userGroupName,
    this.lastSeen,
    this.email,
    this.phone,
    this.password,
    this.gender,
    this.responses,
    this.comments,
    this.paymentMode,
    this.isActive,
    this.isDeleted,
    this.isOnboarded,
    this.groupUID,
    this.profilePhotoURL,
    this.rewardAmount,
    this.secondaryEmail
  });

  Map<String, dynamic> toMap() {
    var participant = <String, dynamic>{};

    participant['participantUID'] = participantUID;
    participant['displayName'] = displayName;
    participant['userFirstName'] = userFirstName;
    participant['userLastName'] = userLastName;
    participant['userGroupName'] = userGroupName;
    participant['lastSeen'] = lastSeen;
    participant['email'] = email;
    participant['phone'] = phone;
    participant['password'] = password;
    participant['gender'] = gender;
    participant['responses'] = responses;
    participant['comments'] = comments;
    participant['paymentMode'] = paymentMode;
    participant['isActive'] = isActive;
    participant['isDeleted'] = isDeleted;
    participant['groupUID'] = groupUID;
    participant['isOnboarded'] = isOnboarded;
    participant['profilePhotoURL'] = profilePhotoURL;
    participant['rewardAmount'] = rewardAmount;
    participant['secondaryEmail'] = secondaryEmail;

    return participant;
  }

  Participant.fromMap(Map<String, dynamic> participant){
    participantUID = participant['participantUID'];
    displayName = participant['displayName'];
    userFirstName = participant['userFirstName'];
    userLastName = participant['userLastName'];
    userGroupName = participant['userGroupName'];
    lastSeen = participant['lastSeen'];
    email = participant['email'];
    phone = participant['phone'];
    password = participant['password'];
    gender = participant['gender'];
    responses = participant['responses'];
    comments = participant['comments'];
    paymentMode = participant['paymentMode'];
    isActive = participant['isActive'];
    isDeleted = participant['isDeleted'];
    isOnboarded = participant['isOnboarded'];
    groupUID = participant['groupUID'];
    profilePhotoURL = participant['profilePhotoURL'];
    rewardAmount = participant['rewardAmount'];
    secondaryEmail = participant['secondaryEmail'];
  }
}
