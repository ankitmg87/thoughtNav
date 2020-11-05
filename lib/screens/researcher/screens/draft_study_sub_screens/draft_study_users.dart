
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class DraftStudyUsers extends StatefulWidget {
  final String studyUID;
  final BuildContext context;

  const DraftStudyUsers({Key key, this.studyUID, this.context})
      : super(key: key);

  @override
  _DraftStudyUsersState createState() => _DraftStudyUsersState();
}

class _DraftStudyUsersState extends State<DraftStudyUsers> {
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  List<Participant> _participants = [];
  List<Client> _clients = [];
  List<Moderator> _moderators = [];

  Future<void> _futureParticipants;
  Future<void> _futureClients;
  Future<void> _futureModerators;

  String _masterPassword;

  @override
  void initState() {
    super.initState();
    _getMasterPassword();
    _futureParticipants = _getParticipants();
    _futureClients = _getClients();
    _futureModerators = _getModerators();
  }

  void _getMasterPassword() async {
    _masterPassword =
        await _firebaseFirestoreService.getMasterPassword(widget.studyUID);
  }

  Future<void> _getParticipants() async {
    _participants =
        await _firebaseFirestoreService.getParticipants(widget.studyUID);
  }

  Future<void> _getClients() async {
    _clients = await _firebaseFirestoreService.getClients(widget.studyUID);
  }

  Future<void> _getModerators() async {
    _moderators =
        await _firebaseFirestoreService.getModerators(widget.studyUID);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Participants',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FlatButton(
                onPressed: () => _buildGeneralDialog('Add Participants',
                    screenSize, 'Enter participant\'s email',
                    onTap: () {}),
                color: PROJECT_GREEN,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 8.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.add_circled,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Participant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 10.0,
          ),
          _buildTitleRow(),
          SizedBox(
            height: 10.0,
          ),
          FutureBuilder(
            future: _futureParticipants,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: _participants.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10.0,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_participants[index].email}',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_participants[index].phone}',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_participants[index].userGroupName}',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clients',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FlatButton(
                onPressed: () => _buildGeneralDialog(
                    'Add Clients', screenSize, 'Enter client\'s email',
                    onTap: () {}),
                color: PROJECT_GREEN,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 8.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.add_circled,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Client',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 10.0,
          ),
          _buildTitleRow(),
          SizedBox(
            height: 10.0,
          ),
          FutureBuilder(
            future: _futureClients,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_clients[index].email}',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_clients[index].phone}',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_clients[index].userGroupName}',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10.0,
                    );
                  },
                  itemCount: _clients.length,
                );
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Moderators',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FlatButton(
                onPressed: () => _buildGeneralDialog(
                    'Add Moderators', screenSize, 'Enter moderator\'s email',
                    onTap: () {}),
                color: PROJECT_GREEN,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 8.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.add_circled,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Moderator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 20.0,
          ),
          _buildTitleRow(),
          SizedBox(
            height: 10.0,
          ),
          FutureBuilder(
            future: _futureModerators,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_moderators[index].email}',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_moderators[index].phone}',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${_moderators[index].userGroupName}',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10.0,
                    );
                  },
                  itemCount: _clients.length,
                );
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  void _pickFile() async {
    List<String> strings;

    var result = await FilePicker.platform.pickFiles();

    if (result != null) {
      var file = result.files.first;

      var uInt8List = file.bytes;

      var string = String.fromCharCodes(uInt8List);

      var list = CsvToListConverter().convert(string);

      print(list.length);
    }
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Email',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phone',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Group',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFutureBuilder(Future future, List<dynamic> list) {
    return Row(
      children: [
        SizedBox(
          width: 20.0,
        ),
        FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10.0,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  );
                },
                itemCount: list.length,
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }

  void _buildGeneralDialog(String heading, Size screenSize, String hintText,
      {Function onTap}) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: heading,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            width: screenSize.width * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Material(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        heading,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: hintText,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                            width: 0.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: InkWell(
                      onTap: () => _pickFile(),
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.tray_arrow_down_fill,
                                color: PROJECT_GREEN,
                                size: 14.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Import .csv file',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          FlatButton(
                            onPressed: onTap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            color: PROJECT_GREEN,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
