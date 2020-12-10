class Client {
  String id;
  String clientUID;
  String email;
  String password;
  String phone;
  String userGroupName;
  bool isOnboarded;

  Client({
    this.id,
    this.clientUID,
    this.email,
    this.password,
    this.phone,
    this.userGroupName,
    this.isOnboarded,
  });

  Map<String, dynamic> toMap(){
    var clientMap = <String, dynamic>{};

    clientMap['id'] = id;
    clientMap['clientUID'] = clientUID;
    clientMap['email'] = email;
    clientMap['password'] = password;
    clientMap['phone'] = phone;
    clientMap['userGroupName'] = userGroupName ?? 'Unassigned';
    clientMap['isOnboarded'] = isOnboarded;

    return clientMap;
  }

  Client.fromMap(Map<String, dynamic> clientMap){
    id = clientMap['id'];
    clientUID = clientMap['clientUID'];
    email = clientMap['email'];
    password = clientMap['password'];
    phone = clientMap['phone'];
    userGroupName = clientMap['userGroupName'];
    isOnboarded = clientMap['isOnboarded'];
  }

}
