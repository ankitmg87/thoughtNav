import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_widgets/client_tile.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_widgets/moderator_tile.dart';
import 'package:thoughtnav/screens/researcher/screens/draft_study_sub_screens/draft_study_widgets/participant_tile.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class DraftStudyUsers extends StatefulWidget {
  final String studyUID;

  const DraftStudyUsers({Key key, this.studyUID}) : super(key: key);

  @override
  _DraftStudyUsersState createState() => _DraftStudyUsersState();
}

class _DraftStudyUsersState extends State<DraftStudyUsers> {
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  List<Group> _groups = [];

  List<Participant> _participants = [];
  List<Client> _clients = [];
  List<Moderator> _moderators = [];

  List<String> _selectedUserUID = [];

  bool _participantsListSelected;
  bool _clientsListSelected;
  bool _moderatorsListSelected;

  Future<void> _futureParticipants;
  Future<void> _futureClients;
  Future<void> _futureModerators;

  FutureBuilder _participantsFutureBuilder;
  FutureBuilder _clientsFutureBuilder;
  FutureBuilder _moderatorsFutureBuilder;

  RaisedButton _addUserButton;

  Widget _list;

  String _masterPassword;

  bool _editing = false;

  void _getGroups() async {
    _groups = await _firebaseFirestoreService.getGroups(widget.studyUID);
  }

  void _addUserToFirebase(
      String email, String masterPassword, String userType, String id) async {
    var user = User(
      userEmail: email,
      userPassword: masterPassword,
      userType: userType,
      studyUID: widget.studyUID,
    );

    var createdUser = await _firebaseFirestoreService.createUser(user);

    if (userType == 'participant') {
      var participant = Participant(
        id: id,
        email: email,
        password: masterPassword,
        isActive: false,
        isDeleted: false,
        isOnboarded: false,
        participantUID: createdUser.userUID,
      );
      await _firebaseFirestoreService.createParticipant(
          widget.studyUID, participant);
      return;
    }
    if (userType == 'client') {
      var client = Client(
        id: id,
        email: email,
        password: masterPassword,
        clientUID: createdUser.userUID,
        phone: '123123123',
        isOnboarded: false,
      );
      client =
          await _firebaseFirestoreService.createClient(widget.studyUID, client);
      _clients.add(client);
      return;
    }
    if (userType == 'moderator') {
      var moderator = Moderator(
        id: id,
        email: email,
        password: masterPassword,
        moderatorUID: createdUser.userUID,
        phone: '789789789',
      );

      moderator = await _firebaseFirestoreService.createModerator(
          widget.studyUID, moderator);
      _moderators.add(moderator);
      return;
    }

    setState(() {});
  }

  @override
  void initState() {
    _getGroups();

    _participantsListSelected = true;
    _clientsListSelected = false;
    _moderatorsListSelected = false;

    _addUserButton = _addParticipantsButton();

    super.initState();
    _getMasterPassword();
    _futureParticipants = _getParticipants();
    _futureClients = _getClients();
    _futureModerators = _getModerators();

    _participantsFutureBuilder = _buildParticipantsList();
    _clientsFutureBuilder = _buildClientsList();
    _moderatorsFutureBuilder = _buildModeratorsList();

    _list = _participantsFutureBuilder;
  }

  void _setList(String label) {
    if (label == 'Participants') {
      setState(() {
        _participantsListSelected = true;
        _clientsListSelected = false;
        _moderatorsListSelected = false;

        _list = _participantsFutureBuilder;
        _addUserButton = _addParticipantsButton();
      });
      return;
    }
    if (label == 'Clients') {
      setState(() {
        _participantsListSelected = false;
        _clientsListSelected = true;
        _moderatorsListSelected = false;

        _list = _clientsFutureBuilder;
        _addUserButton = _addClientsButton();
      });
    }
    if (label == 'Moderators') {
      setState(() {
        _participantsListSelected = false;
        _clientsListSelected = false;
        _moderatorsListSelected = true;

        _list = _moderatorsFutureBuilder;
        _addUserButton = _addModeratorsButton();
      });
    }
  }

  RaisedButton _addUsersToGroupButton() {
    return RaisedButton(
      onPressed: () async {},
    );
  }

  RaisedButton _addParticipantsButton() {
    return RaisedButton(
      onPressed: () async {
        // await _buildGeneralDialog('Participants', MediaQuery.of(context).size,
        //     'Participant Email', 'participant', _masterPassword);
        await _buildAddParticipantsDialog();
      },
      color: PROJECT_GREEN,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.add_circled,
              size: 14.0,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Participants',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  RaisedButton _addClientsButton() {
    return RaisedButton(
      onPressed: () async {
        await _buildGeneralDialog('Clients', MediaQuery.of(context).size,
            'Client Name', 'client', _masterPassword);
        setState(() {});
      },
      color: PROJECT_GREEN,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.add_circled,
              size: 14.0,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Clients',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  RaisedButton _addModeratorsButton() {
    return RaisedButton(
      onPressed: () async {
        var userDetails = await _buildGeneralDialog(
            'Moderators',
            MediaQuery.of(context).size,
            'Moderator Name',
            'moderator',
            _masterPassword);

        setState(() {});
      },
      color: PROJECT_GREEN,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.add_circled,
              size: 14.0,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Moderators',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder _buildParticipantsList() {
    return FutureBuilder(
      future: _futureParticipants,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return Center(
            child: Text('Loading participants...'),
          );
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text(
              'Please connect to the internet and try again',
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: _participants.isNotEmpty
                    ? ListView.separated(
                        itemCount: _participants.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10.0,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ParticipantTile(
                            participant: _participants[index],
                            groups: _groups,
                          );
                        },
                      )
                    : Center(
                        child: Text('Please add participants'),
                      ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
                'Something went wrong. Please try again or contact your administrator.'),
          );
        }
      },
    );
  }

  FutureBuilder _buildClientsList() {
    return FutureBuilder(
      future: _futureClients,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return Center(
            child: Text('Loading clients...'),
          );
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text(
              'Please connect to the internet and try again',
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: _clients.isNotEmpty
                    ? ListView.separated(
                        itemCount: _clients.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10.0,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ClientTile(
                            client: _clients[index],
                          );
                        },
                      )
                    : Center(
                        child: Text('Please add clients'),
                      ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
                'Something went wrong. Please try again or contact your administrator.'),
          );
        }
      },
    );
  }

  FutureBuilder _buildModeratorsList() {
    return FutureBuilder(
      future: _futureModerators,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return Center(
            child: Text('Loading moderators...'),
          );
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text(
              'Please connect to the internet and try again',
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: _moderators.isNotEmpty
                    ? ListView.separated(
                        itemCount: _moderators.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10.0,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ModeratorTile(
                            moderator: _moderators[index],
                          );
                        },
                      )
                    : Center(
                        child: Text('Please add moderators'),
                      ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text(
                'Something went wrong. Please try again or contact your administrator.'),
          );
        }
      },
    );
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
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300],
              ),
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              _DraftStudySecondaryAppBarWidget(
                label: 'Participants',
                selected: _participantsListSelected,
                onTap: () => _setList('Participants'),
              ),
              SizedBox(
                width: 16.0,
              ),
              _DraftStudySecondaryAppBarWidget(
                label: 'Clients',
                selected: _clientsListSelected,
                onTap: () => _setList('Clients'),
              ),
              SizedBox(
                width: 16.0,
              ),
              _DraftStudySecondaryAppBarWidget(
                label: 'Moderators',
                selected: _moderatorsListSelected,
                onTap: () => _setList('Moderators'),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _addUserButton,
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: PROJECT_GREEN,
                        size: 16.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _editing = !_editing;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _list),
      ],
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
    }
  }

  Future _buildAddParticipantsDialog() async {
    var email = '';
    var firstName = '';
    var lastName = '';
    var phone = '';

    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) _setState) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width * 0.6,
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
                            'Add Participants',
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  _setState(() {
                                    email = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Participant Email',
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
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  _setState(() {
                                    firstName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'First Name',
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
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  _setState(() {
                                    lastName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
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
                              width: 20.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  _setState(() {
                                    phone = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Participant Phone',
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
                          ],
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
                            ],
                          ),
                        ),
                      ),
                      ButtonBar(
                        children: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            color: Colors.grey[200],
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {},
                            // onPressed: email.isNotEmpty && id.isNotEmpty
                            //     ? () async {
                            //   await _addUserToFirebase(
                            //       email, masterPassword, userType, id);
                            //   Navigator.of(context).pop();
                            //   setState(() {});
                            // }
                            //     : null,
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future _buildGeneralDialog(String heading, Size screenSize, String hintText,
      String userType, String masterPassword) async {
    var email = '';
    var id = '';
    await showGeneralDialog(
      context: context,
      barrierLabel: heading,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) _setState) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
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
                        child: Row(
                          children: [
                            // SizedBox(
                            //   width: 60.0,
                            //   child: TextFormField(
                            //     onChanged: (value) {
                            //       _setState(() {
                            //         id = value;
                            //       });
                            //     },
                            //     decoration: InputDecoration(
                            //       hintText: 'No.',
                            //       focusedBorder: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(2.0),
                            //         borderSide: BorderSide(
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //       enabledBorder: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(2.0),
                            //         borderSide: BorderSide(
                            //           color: Colors.grey[400],
                            //           width: 0.5,
                            //         ),
                            //       ),
                            //       border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(2.0),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 20.0,
                            // ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  _setState(() {
                                    email = value;
                                  });
                                },
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
                          ],
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
                            ],
                          ),
                        ),
                      ),
                      ButtonBar(
                        children: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            color: Colors.grey[200],
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: email.isNotEmpty && id.isNotEmpty
                                ? () async {
                                    await _addUserToFirebase(
                                        email, masterPassword, userType, id);
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  }
                                : null,
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (email.isNotEmpty && id.isNotEmpty) {
      return {
        'email': email,
        'id': id,
      };
    } else {
      return;
    }
  }
}

class _DraftStudySecondaryAppBarWidget extends StatefulWidget {
  final String label;
  final bool selected;
  final Function onTap;

  const _DraftStudySecondaryAppBarWidget(
      {Key key, this.label, this.selected, this.onTap})
      : super(key: key);

  @override
  __DraftStudySecondaryAppBarWidgetState createState() =>
      __DraftStudySecondaryAppBarWidgetState();
}

class __DraftStudySecondaryAppBarWidgetState
    extends State<_DraftStudySecondaryAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        widget.label,
        style: TextStyle(
          color: widget.selected ? PROJECT_GREEN : Colors.grey[700],
          fontWeight: FontWeight.w900,
          fontSize: 14.0,
        ),
      ),
      onTap: widget.onTap,
      hoverColor: Colors.white,
      splashColor: Colors.white,
      highlightColor: Colors.white,
    );
  }
}
