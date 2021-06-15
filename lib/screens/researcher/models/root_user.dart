// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

class RootUser{

  String profilePictureUrl;

  RootUser({this.profilePictureUrl});

  Map<String, dynamic> toMap(){
    var rootUserMap = <String, dynamic>{};

    rootUserMap['profilePictureUrl'] = profilePictureUrl;

    return rootUserMap;
  }

  RootUser.fromMap(Map<String, dynamic> rootUserMap){
    profilePictureUrl = rootUserMap['profilePictureUrl'];
  }

}