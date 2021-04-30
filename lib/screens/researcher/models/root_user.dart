// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

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