class Client {
  String uid;
  String email;
  String password;
  String phone;
  String userGroupName;

  Client({
    this.uid,
    this.email,
    this.password,
    this.phone,
    this.userGroupName,
  });

  Map<String, dynamic> toMap(){
    var clientMap = <String, dynamic>{};

    clientMap['uid'] = uid;
    clientMap['email'] = email;
    clientMap['password'] = password;
    clientMap['phone'] = phone;
    clientMap['userGroupName'] = userGroupName ?? 'Unassigned';

    return clientMap;
  }

  Client.fromMap(Map<String, dynamic> client){
    uid = client['uid'];
    email = client['email'];
    password = client['password'];
    phone = client['phone'];
    userGroupName = client['userGroupName'];
  }

}
