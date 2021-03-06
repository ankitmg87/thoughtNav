// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

/// This file defines the client model

class Client {
  String clientUID;
  String clientAvatarURL;
  String email;
  String firstName;
  String lastName;
  String password;
  String phone;

  Client({
    this.clientUID,
    this.clientAvatarURL,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.phone,
  });

  Map<String, dynamic> toMap(){
    var clientMap = <String, dynamic>{};

    clientMap['clientUID'] = clientUID;
    clientMap['clientAvatarURL'] = clientAvatarURL;
    clientMap['email'] = email;
    clientMap['firstName'] = firstName;
    clientMap['lastName'] = lastName;
    clientMap['password'] = password;
    clientMap['phone'] = phone;

    return clientMap;
  }

  Client.fromMap(Map<String, dynamic> clientMap){
    clientUID = clientMap['clientUID'];
    clientAvatarURL = clientMap['clientAvatarURL'];
    email = clientMap['email'];
    firstName = clientMap['firstName'];
    lastName = clientMap['lastName'];
    password = clientMap['password'];
    phone = clientMap['phone'];
  }

}
