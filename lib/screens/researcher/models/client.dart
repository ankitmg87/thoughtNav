class Client {
  String id;
  String uid;
  String email;
  String password;
  String phone;
  String userGroupName;

  Client({
    this.id,
    this.uid,
    this.email,
    this.password,
    this.phone,
    this.userGroupName,
  });

  Map<String, dynamic> toMap(){
    var clientMap = <String, dynamic>{};

    clientMap['id'] = id;
    clientMap['uid'] = uid;
    clientMap['email'] = email;
    clientMap['password'] = password;
    clientMap['phone'] = phone;
    clientMap['userGroupName'] = userGroupName ?? 'Unassigned';

    return clientMap;
  }

  Client.fromMap(Map<String, dynamic> clientMap){
    id = clientMap['id'];
    uid = clientMap['uid'];
    email = clientMap['email'];
    password = clientMap['password'];
    phone = clientMap['phone'];
    userGroupName = clientMap['userGroupName'];
  }

}
