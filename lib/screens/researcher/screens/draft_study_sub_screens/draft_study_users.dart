// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class DraftStudyUsers extends StatefulWidget {
  final String studyUID;

  const DraftStudyUsers({Key key, this.studyUID}) : super(key: key);

  @override
  _DraftStudyUsersState createState() => _DraftStudyUsersState();
}

class _DraftStudyUsersState extends State<DraftStudyUsers> {
  final FirebaseFirestoreService _firebaseFirestoreService =
  FirebaseFirestoreService();

  final _researcherAndModeratorFirestoreService =
  ResearcherAndModeratorFirestoreService();

  final _phoneFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####', filter: {'#': RegExp(r'[0-9]')});

  List<Group> _groups = [];

  List<Participant> _participants = [];

  bool _participantsListSelected;
  bool _clientsListSelected;
  bool _moderatorsListSelected;

  Stream<QuerySnapshot> _participantStream;
  Stream<QuerySnapshot> _clientsStream;
  Stream<QuerySnapshot> _moderatorsStream;

  StreamBuilder<QuerySnapshot> _participantsStreamBuilder;
  StreamBuilder<QuerySnapshot> _clientsStreamBuilder;
  StreamBuilder<QuerySnapshot> _moderatorsStreamBuilder;

  RaisedButton _addUserButton;

  Widget _list;

  String _masterPassword;

  void _getGroups() async {
    _groups = await _firebaseFirestoreService.getGroups(widget.studyUID);
    setState(() {
      _participantStream = _getParticipantsStream(widget.studyUID);
      _participantsStreamBuilder = _buildParticipantsList(_participantStream);
      _list = _participantsStreamBuilder;
      _clientsStream = _getClientsStream(widget.studyUID);
      _clientsStreamBuilder = _buildClientsList(_clientsStream);
      _moderatorsStream = _getModeratorsStream();
      _moderatorsStreamBuilder = _buildModeratorsList(_moderatorsStream);
    });
  }

  Stream<QuerySnapshot> _getParticipantsStream(String studyUID) {
    return _researcherAndModeratorFirestoreService
        .getParticipantsAsStream(studyUID);
  }

  Stream<QuerySnapshot> _getClientsStream(String studyUID) {
    return _researcherAndModeratorFirestoreService.getClientsAsStream(studyUID);
  }

  Stream<QuerySnapshot> _getModeratorsStream() {
    return _researcherAndModeratorFirestoreService.getModeratorsAsStream();
  }

  Future<void> _addParticipantToFirebase(
      String studyUID, Participant participant) async {
    var user = User(
      userEmail: participant.email.toLowerCase(),
      userPassword: _masterPassword,
      userType: 'participant',
      studyUID: studyUID,
    );

    var createdUser = await _firebaseFirestoreService.createUser(user);

    if(createdUser != null){
      participant.participantUID = createdUser.userUID;
      participant.isActive = false;
      participant.isOnboarded = false;
      participant.isDeleted = false;
      participant.password = _masterPassword;
      participant.responses = 0;
      participant.comments = 0;

      await _researcherAndModeratorFirestoreService.createParticipant(
          studyUID, participant);
    }
  }

  Future<void> _addClientToFirebase(String studyUID, Client client) async {
    var user = User(
      userEmail: client.email.toLowerCase(),
      userPassword: _masterPassword,
      userType: 'client',
      studyUID: studyUID,
    );

    var createdUser = await _firebaseFirestoreService.createUser(user);

    if(createdUser != null){
      client.clientUID = createdUser.userUID;
      client.password = _masterPassword;

      await _researcherAndModeratorFirestoreService.createClient(
          studyUID, client);
    }
  }

  Future<void> _addModeratorToFirebase(
      String studyUID, Moderator moderator) async {
    var user = User(
      userEmail: moderator.email.toLowerCase(),
      userPassword: moderator.password,
      userType: 'moderator',
    );

    var createdUser = await _firebaseFirestoreService.createUser(user);

    if(createdUser != null){
      moderator.moderatorUID = createdUser.userUID;
      moderator.assignedStudies = [];
      moderator.assignedStudies.add(studyUID);

      await _researcherAndModeratorFirestoreService.createModerator(moderator);
    }
  }

  void _downloadFile(String url) {
    var anchorElement = AnchorElement(href: url);
    anchorElement.download = url;
  }

  void _setList(String label) {
    if (label == 'Participants') {
      setState(() {
        _participantsListSelected = true;
        _clientsListSelected = false;
        _moderatorsListSelected = false;

        _list = _participantsStreamBuilder;
        _addUserButton = _addParticipantsButton();
      });
      return;
    }
    if (label == 'Clients') {
      setState(() {
        _participantsListSelected = false;
        _clientsListSelected = true;
        _moderatorsListSelected = false;

        _list = _clientsStreamBuilder;
        _addUserButton = _addClientsButton();
      });
    }
    if (label == 'Moderators') {
      setState(() {
        _participantsListSelected = false;
        _clientsListSelected = false;
        _moderatorsListSelected = true;

        _list = _moderatorsStreamBuilder;
        _addUserButton = _addModeratorsButton();
      });
    }
  }

  void _getMasterPassword() async {
    _masterPassword = await _researcherAndModeratorFirestoreService
        .getMasterPassword(widget.studyUID);
  }

  StreamBuilder<QuerySnapshot> _buildParticipantsList(
      Stream<QuerySnapshot> participantStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: participantStream,
      builder: (BuildContext participantsListStreamBuilderContext,
          AsyncSnapshot<QuerySnapshot> participantsSnapshot) {
        switch (participantsSnapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text(
                'Please wait',
              ),
            );
            break;
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Please wait',
              ),
            );
            break;
          case ConnectionState.active:
            if (participantsSnapshot.hasData) {
              _participants = <Participant>[];

              for (var participantSnapshot in participantsSnapshot.data.docs) {
                _participants
                    .add(Participant.fromMap(participantSnapshot.data()));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _groups.length,
                  itemBuilder: (BuildContext groupListContext, int groupIndex) {
                    var groupParticipants = <Participant>[];

                    for (var participant in _participants) {
                      if (_groups[groupIndex].groupName ==
                          participant.userGroupName) {
                        groupParticipants.add(participant);
                      }
                    }

                    groupParticipants
                        .sort((a, b) => a.email.compareTo(b.email));

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _groups[groupIndex].groupName,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
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
                          height: 16.0,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: groupParticipants.length,
                          itemBuilder: (BuildContext participantListContext,
                              int groupParticipantsIndex) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    groupParticipants[groupParticipantsIndex]
                                        .email,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${groupParticipants[groupParticipantsIndex].userFirstName}'
                                        ' ${groupParticipants[groupParticipantsIndex].userLastName}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    groupParticipants[groupParticipantsIndex]
                                        .userGroupName,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    groupParticipants[groupParticipantsIndex]
                                        .phone ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await _buildEditParticipantDialog(
                                        groupParticipants[
                                        groupParticipantsIndex],
                                        _groups);
                                  },
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: PROJECT_LIGHT_GREEN,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey[700],
                                      size: 16.0,
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
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 30.0,
                    );
                  },
                ),
              );
            } else {
              return SizedBox();
            }
            break;
          case ConnectionState.done:
            return Center(
              child: Text(
                'Something went wrong',
              ),
            );
            break;
          default:
            return Center(
              child: Text(
                'Something went wrong',
              ),
            );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot> _buildClientsList(
      Stream<QuerySnapshot> clientsStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: clientsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text(
                'Please wait',
              ),
            );
            break;
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Please wait',
              ),
            );
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
              var clients = <Client>[];

              for (var client in snapshot.data.docs) {
                clients.add(Client.fromMap(client.data()));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clients',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
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
                      height: 16.0,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: clients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                clients[index].email,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                clients[index].firstName,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                clients[index].lastName,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                clients[index].phone ?? '',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () async {
                                await _buildEditClientDialog(clients[index]);
                              },
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: PROJECT_LIGHT_GREEN,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.grey[700],
                                  size: 16.0,
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
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
            break;
          case ConnectionState.done:
            return Center(
              child: Text(
                'Something went wrong',
              ),
            );
            break;
          default:
            return Center(
              child: Text(
                'Something went wrong',
              ),
            );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot> _buildModeratorsList(
      Stream<QuerySnapshot> moderatorsStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: moderatorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text(
                'Please wait',
              ),
            );
            break;
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Please wait',
              ),
            );
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
              var moderatorAssignedToThisStudy = <Moderator>[];
              var moderatorsNotAssignedToThisStudy = <Moderator>[];

              for (var moderatorSnapshot in snapshot.data.docs) {
                var moderator = Moderator.fromMap(moderatorSnapshot.data());

                if (moderator.assignedStudies.contains(widget.studyUID)) {
                  moderatorAssignedToThisStudy.add(moderator);
                } else {
                  moderatorsNotAssignedToThisStudy.add(moderator);
                }
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: ListView(
                  children: [
                    moderatorAssignedToThisStudy.isEmpty
                        ? SizedBox()
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assigned to this study:',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
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
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: moderatorAssignedToThisStudy.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    moderatorAssignedToThisStudy[index]
                                        .email,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    moderatorAssignedToThisStudy[index]
                                        .firstName,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    moderatorAssignedToThisStudy[index]
                                        .lastName,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    moderatorAssignedToThisStudy[index]
                                        .phone ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await _buildEditModeratorDialog(moderatorAssignedToThisStudy[index]);
                                  },
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: PROJECT_LIGHT_GREEN,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey[700],
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return SizedBox(
                              height: 10.0,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    moderatorsNotAssignedToThisStudy.isEmpty
                        ? SizedBox()
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Not assigned to this study:',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
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
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          moderatorsNotAssignedToThisStudy.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    moderatorsNotAssignedToThisStudy[
                                    index]
                                        .email,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    moderatorsNotAssignedToThisStudy[
                                    index]
                                        .firstName,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    moderatorsNotAssignedToThisStudy[
                                    index]
                                        .lastName,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    moderatorsNotAssignedToThisStudy[
                                    index]
                                        .phone ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await _buildEditModeratorDialog(moderatorsNotAssignedToThisStudy[
                                    index]);
                                  },
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: PROJECT_LIGHT_GREEN,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey[700],
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return SizedBox(
                              height: 10.0,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
            break;
          case ConnectionState.done:
            return Center(
              child: Text(
                'Something went wrong',
              ),
            );
            break;
          default:
            return Center(
              child: Text(
                'Something went wrong',
              ),
            );
        }
      },
    );
  }

  Future<void> _buildEditParticipantDialog(
      Participant participant, List<Group> groups) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext generalDialogContext,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        int value;

        for (var i = 0; i < groups.length; i++) {
          if (participant.userGroupName == groups[i].groupName) {
            value = i;
          }
        }
        return StatefulBuilder(
          builder: (BuildContext statefulBuilderContext,
              void Function(void Function()) stateFulBuilderSetState) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Edit Participant',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: participant.email,
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    participant.email = value.trim();
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
                                initialValue: participant.userFirstName,
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    participant.userFirstName = value.trim();
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
                                initialValue: participant.userLastName,
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    participant.userLastName = value.trim();
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
                                initialValue: participant.phone,
                                inputFormatters: [_phoneFormatter],
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    participant.phone = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Phone',
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
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select Participant Group',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 10.0,
                            children: List<Widget>.generate(_groups.length,
                                    (int index) {
                                  return ChoiceChip(
                                    elevation: 2.0,
                                    padding: EdgeInsets.all(10.0),
                                    selectedColor: PROJECT_GREEN,
                                    backgroundColor: Colors.grey[100],
                                    label: Text(
                                      '${_groups[index].groupName}',
                                      style: TextStyle(
                                        color: value == index
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: value == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    selected: value == index,
                                    onSelected: (bool selected) {
                                      stateFulBuilderSetState(() {
                                        value = selected ? index : null;
                                        participant.groupUID =
                                            _groups[index].groupUID;
                                        participant.userGroupName =
                                            _groups[index].groupName;
                                        participant.rewardAmount =
                                            _groups[index].groupRewardAmount;
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () =>
                                  Navigator.of(generalDialogContext).pop(),
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
                              disabledColor: Colors.grey[700],
                              onPressed: participant.email != '' &&
                                  participant.userFirstName != '' &&
                                  participant.userLastName != '' &&
                                  participant.groupUID != ''
                                  ? () async {
                                await _researcherAndModeratorFirestoreService
                                    .updateParticipantDetails(
                                    widget.studyUID, participant);
                                Navigator.of(generalDialogContext).pop();
                              }
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              color: PROJECT_GREEN,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Update',
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
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _buildEditClientDialog(Client client) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext generalDialogContext,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) editClientSetState) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Edit Client',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: client.email,
                                onChanged: (value) {
                                  editClientSetState(() {
                                    client.email = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Client Email',
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
                                initialValue: client.firstName,
                                onChanged: (value) {
                                  editClientSetState(() {
                                    client.firstName = value.trim();
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
                                initialValue: client.lastName,
                                onChanged: (value) {
                                  editClientSetState(() {
                                    client.lastName = value.trim();
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
                                initialValue: client.phone,
                                inputFormatters: [_phoneFormatter],
                                onChanged: (value) {
                                  editClientSetState(() {
                                    client.phone = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Phone',
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
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () =>
                                  Navigator.of(generalDialogContext).pop(),
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
                              disabledColor: Colors.grey[700],
                              onPressed: client.email != '' &&
                                  client.firstName != '' &&
                                  client.lastName != ''
                                  ? () async {
                                await _researcherAndModeratorFirestoreService
                                    .updateClientDetails(
                                    widget.studyUID, client);
                                Navigator.of(generalDialogContext).pop();
                              }
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              color: PROJECT_GREEN,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Update',
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
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _buildEditModeratorDialog(Moderator moderator) async {
    var assignedStudies = moderator.assignedStudies;

    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext generalDialogContext,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) editModeratorSetState) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Edit Moderator',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: moderator.email,
                                onChanged: (value) {
                                  editModeratorSetState(() {
                                    moderator.email = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Moderator Email',
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
                                initialValue: moderator.firstName,
                                onChanged: (value) {
                                  editModeratorSetState(() {
                                    moderator.firstName = value.trim();
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
                                initialValue: moderator.lastName,
                                onChanged: (value) {
                                  editModeratorSetState(() {
                                    moderator.lastName = value.trim();
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
                                initialValue: moderator.phone,
                                inputFormatters: [_phoneFormatter],
                                onChanged: (value) {
                                  editModeratorSetState(() {
                                    moderator.phone = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Phone',
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
                        SizedBox(
                          height: 20.0,
                        ),
                        moderator.assignedStudies.contains(widget.studyUID)
                            ? Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.grey[700],
                            accentColor: PROJECT_NAVY_BLUE,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                onChanged: (bool value) {
                                  value ? assignedStudies.add(widget.studyUID) : assignedStudies.remove(widget.studyUID);
                                  editModeratorSetState((){});
                                },
                                value:
                                assignedStudies.contains(widget.studyUID),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Un-assign this study',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        )
                            : Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.grey[700],
                            accentColor: PROJECT_NAVY_BLUE,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                onChanged: (bool value) {
                                  value ? assignedStudies.add(widget.studyUID) : assignedStudies.remove(widget.studyUID);
                                  editModeratorSetState((){});
                                },
                                value:
                                assignedStudies.contains(widget.studyUID),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Assign this study',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),

                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () =>
                                  Navigator.of(generalDialogContext).pop(),
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
                              disabledColor: Colors.grey[700],
                              onPressed: moderator.email != '' &&
                                  moderator.firstName != '' &&
                                  moderator.lastName != ''
                                  ? () async {
                                moderator.assignedStudies = assignedStudies;
                                await _researcherAndModeratorFirestoreService
                                    .updateModeratorDetails(moderator);
                                Navigator.of(generalDialogContext).pop();
                              }
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              color: PROJECT_GREEN,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Update',
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
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Participant>> _pickFile() async {
    var participants = <Participant>[];

    var result = await FilePicker.platform.pickFiles();

    if (result != null) {
      var file = result.files.first;

      var uInt8List = file.bytes;

      var string = String.fromCharCodes(uInt8List);

      var list = CsvToListConverter(
        fieldDelimiter: ',',
      ).convert(string);

      for (var i = 1; i < list.length; i++) {
        var participant = Participant(
          email: list[i][0].toString(),
          userFirstName: list[i][1].toString(),
          userLastName: list[i][2].toString(),
        );
        for (var group in _groups) {
          if (group.groupName.toLowerCase() ==
              list[i][3].toString().toLowerCase()) {
            participant.groupUID = group.groupUID;
            participant.rewardAmount = group.groupRewardAmount;
            participant.userGroupName = group.groupName;
          }
        }
        if (list[i][4] != null) {
          participant.phone = list[i][4];
        }
        participants.add(participant);
      }
    }
    return participants;
  }

  Future _buildAddParticipantsDialog() async {
    var email = '';
    var firstName = '';
    var lastName = '';
    var phone = '';
    var groupUID = '';

    var participant = Participant();

    var addingParticipant = false;

    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext generalDialogContext,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        var value;

        return StatefulBuilder(
          builder: (BuildContext statefulBuilderContext,
              void Function(void Function()) stateFulBuilderSetState) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: addingParticipant
                    ? Material(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Please Wait...',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                )
                    : Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Add Participants',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    email = value.trim();
                                    participant.email = value.trim().toLowerCase();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Participant Email',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  stateFulBuilderSetState(() {
                                    firstName = value.trim();
                                    participant.userFirstName =
                                        value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  stateFulBuilderSetState(() {
                                    lastName = value.trim();
                                    participant.userLastName =
                                        value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  stateFulBuilderSetState(() {
                                    phone = value.trim();
                                    participant.phone = phone;
                                  });
                                },
                                inputFormatters: [
                                  _phoneFormatter,
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Phone',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select Participant Group',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 10.0,
                            children: List<Widget>.generate(
                                _groups.length, (int index) {
                              return ChoiceChip(
                                elevation: 2.0,
                                padding: EdgeInsets.all(10.0),
                                selectedColor: PROJECT_GREEN,
                                backgroundColor: Colors.grey[100],
                                label: Text(
                                  '${_groups[index].groupName}',
                                  style: TextStyle(
                                    color: value == index
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: value == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: value == index,
                                onSelected: (bool selected) {
                                  stateFulBuilderSetState(() {
                                    value = selected ? index : null;
                                    groupUID = _groups[index].groupUID;
                                    participant.groupUID =
                                        _groups[index].groupUID;
                                    participant.userGroupName =
                                        _groups[index].groupName;
                                    participant.rewardAmount =
                                        _groups[index].groupRewardAmount;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  var participants = await _pickFile();

                                  if (participants.isNotEmpty) {
                                    stateFulBuilderSetState(() {
                                      addingParticipant = true;
                                    });

                                    for (var participant
                                    in participants) {
                                      try {
                                        await _addParticipantToFirebase(
                                            widget.studyUID, participant);
                                      } catch (e) {
                                        print(e);
                                      }
                                    }

                                    Navigator.of(generalDialogContext)
                                        .pop();
                                  }
                                },
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                child: Row(
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
                              ),
                              InkWell(
                                onTap: () async {
                                  _downloadFile('');
                                },
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      CupertinoIcons.arrow_down_doc,
                                      color: PROJECT_GREEN,
                                      size: 14.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'Download sample .csv file',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () =>
                                  Navigator.of(generalDialogContext)
                                      .pop(),
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
                              disabledColor: Colors.grey[700],
                              onPressed: email != '' &&
                                  firstName != '' &&
                                  lastName != '' &&
                                  groupUID != ''
                                  ? () async {
                                stateFulBuilderSetState(() {
                                  addingParticipant = true;
                                });
                                await _addParticipantToFirebase(
                                    widget.studyUID, participant);
                                Navigator.of(generalDialogContext)
                                    .pop();
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
              ),
            );
          },
        );
      },
    );
  }

  Future _buildAddClientsDialog() async {
    var email = '';
    var firstName = '';
    var lastName = '';
    var phone = '';

    var client = Client();

    var addingClient = false;

    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext clientGeneralDialogContext,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext statefulBuilderContext,
              void Function(void Function()) statefulBuilderSetState) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: addingClient
                    ? Material(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Please Wait...',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                )
                    : Material(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Add Clients',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  statefulBuilderSetState(() {
                                    email = value.trim();
                                    client.email = value.trim().toLowerCase();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Client Email',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  statefulBuilderSetState(() {
                                    firstName = value.trim();
                                    client.firstName = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  statefulBuilderSetState(() {
                                    lastName = value.trim();
                                    client.lastName = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  statefulBuilderSetState(() {
                                    phone = value.trim();
                                    client.phone = value.trim();
                                  });
                                },
                                inputFormatters: [_phoneFormatter],
                                decoration: InputDecoration(
                                  hintText: 'Phone',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () =>
                                  Navigator.of(clientGeneralDialogContext)
                                      .pop(),
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
                              disabledColor: Colors.grey[700],
                              onPressed: email != '' &&
                                  firstName != '' &&
                                  lastName != ''
                                  ? () async {
                                statefulBuilderSetState(() {
                                  addingClient = true;
                                });
                                await _addClientToFirebase(
                                    widget.studyUID, client);
                                Navigator.of(
                                    clientGeneralDialogContext)
                                    .pop();
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
              ),
            );
          },
        );
      },
    );
  }

  Future _buildAddModeratorsDialog() async {
    var email = '';
    var firstName = '';
    var lastName = '';
    var password = '';
    var phone = '';

    var moderator = Moderator();

    var addingModerator = false;

    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext moderatorGeneralDialogContext,
              void Function(void Function()) statefulBuilderSetState) {
            return Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                    maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: addingModerator
                    ? Material(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Please Wait...',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                )
                    : Material(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Add Moderators',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  statefulBuilderSetState(() {
                                    email = value.trim();
                                    moderator.email = value.trim().toLowerCase();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  statefulBuilderSetState(() {
                                    firstName = value.trim();
                                    moderator.firstName = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  statefulBuilderSetState(() {
                                    lastName = value.trim();
                                    moderator.lastName = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  statefulBuilderSetState(() {
                                    password = value.trim();
                                    moderator.password = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
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
                                  statefulBuilderSetState(() {
                                    phone = value.trim();
                                    moderator.phone = value.trim();
                                  });
                                },
                                inputFormatters: [_phoneFormatter],
                                decoration: InputDecoration(
                                  hintText: 'Phone',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 0.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () => Navigator.of(
                                  moderatorGeneralDialogContext)
                                  .pop(),
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
                              disabledColor: Colors.grey[700],
                              onPressed: email != '' &&
                                  firstName != '' &&
                                  lastName != '' &&
                                  password != ''
                                  ? () async {
                                statefulBuilderSetState(() {
                                  addingModerator = true;
                                });
                                await _addModeratorToFirebase(
                                    widget.studyUID, moderator);
                                Navigator.of(
                                    moderatorGeneralDialogContext)
                                    .pop();
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
              ),
            );
          },
        );
      },
    );
  }

  RaisedButton _addParticipantsButton() {
    return RaisedButton(
      onPressed: () async {
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
        await _buildAddClientsDialog();
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
        await _buildAddModeratorsDialog();
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

  @override
  void initState() {
    _getGroups();

    _participantsListSelected = true;
    _clientsListSelected = false;
    _moderatorsListSelected = false;

    _addUserButton = _addParticipantsButton();

    super.initState();
    _getMasterPassword();

    _participantsStreamBuilder = _buildParticipantsList(_participantStream);
    _clientsStreamBuilder = _buildClientsList(_clientsStream);
    _moderatorsStreamBuilder = _buildModeratorsList(_moderatorsStream);

    _list = _participantsStreamBuilder;
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
      onTap: widget.onTap,
      hoverColor: Colors.white,
      splashColor: Colors.white,
      highlightColor: Colors.white,
      child: Text(
        widget.label,
        style: TextStyle(
          color: widget.selected ? PROJECT_GREEN : Colors.grey[700],
          fontWeight: FontWeight.w900,
          fontSize: 14.0,
        ),
      ),
    );
  }
}