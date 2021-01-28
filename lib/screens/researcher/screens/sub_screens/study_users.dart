import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/widgets/add_users_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/email_widget.dart';
import 'package:thoughtnav/screens/researcher/widgets/participant_details_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

import 'dart:js' as js;

class StudyUsers extends StatefulWidget {
  final String studyUID;
  final FirebaseFirestoreService firebaseFirestoreService;

  const StudyUsers({Key key, this.studyUID, this.firebaseFirestoreService})
      : super(key: key);

  @override
  _StudyUsersState createState() => _StudyUsersState();
}

class _StudyUsersState extends State<StudyUsers> {
  final _listKey = GlobalKey();

  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  final _searchFocusNode = FocusNode();

  bool _participantsVisible = true;
  bool _clientsVisible = false;
  bool _moderatorsVisible = false;

  bool _multiSelect = false;

  Widget _visibleListView;

  List<Group> _groupsList;

  String _sortBy = 'none';
  String _filterBy = 'none';

  String _masterPassword;

  Stream<QuerySnapshot> _participantStream;
  Stream<QuerySnapshot> _clientsStream;
  Stream<QuerySnapshot> _moderatorsStream;

  List<Participant> _allParticipants = <Participant>[];
  List<Participant> _searchedParticipants = <Participant>[];

  Future<void> _futureGroups;

  Future<void> _getGroups() async {
    _masterPassword = await _researcherAndModeratorFirestoreService
        .getMasterPassword(widget.studyUID);

    _groupsList = await _researcherAndModeratorFirestoreService
        .getGroups(widget.studyUID);
  }

  Stream<QuerySnapshot> _getParticipantsStream() {
    return _researcherAndModeratorFirestoreService
        .getParticipantsAsStream(widget.studyUID);
  }

  Stream<QuerySnapshot> _getClientsStream() {
    return _researcherAndModeratorFirestoreService
        .getClientsAsStream(widget.studyUID);
  }

  Stream<QuerySnapshot> _getModeratorsStream() {
    return _researcherAndModeratorFirestoreService.getModeratorsAsStream();
  }

  List<Participant> _participantsList = [];
  List<Participant> _bulkSelectedParticipants = [];
  List<Participant> _sortedParticipants = [];
  List<Participant> _filteredParticipants = [];

  void _setMultiSelectMode() {
    setState(() {
      _multiSelect = !_multiSelect;
    });
  }

  void _setVisibleListView(String label) {
    switch (label) {
      case 'Participants':
        setState(() {
          _participantsVisible = true;
          _clientsVisible = false;
          _moderatorsVisible = false;

          _visibleListView = _participantsStreamBuilder(_participantStream);

          _bulkSelectedParticipants = [];
          _filterBy = 'none';
          _sortBy = 'none';

        });
        break;
      case 'Clients':
        setState(() {
          _participantsVisible = false;
          _clientsVisible = true;
          _moderatorsVisible = false;

          _visibleListView = _clientsStreamBuilder(_clientsStream);
        });
        break;
      case 'Moderators':
        setState(() {
          _participantsVisible = false;
          _clientsVisible = false;
          _moderatorsVisible = true;

          _visibleListView = _moderatorsStreamBuilder(_moderatorsStream);
        });
        break;
    }
  }

  void _makeSearchedParticipantsList(String searchQuery) {
    _searchedParticipants = [];

    if (searchQuery != null) {
      if (searchQuery.isNotEmpty) {
        for (var participant in _allParticipants) {
          var participantEmail = participant.email.toLowerCase();
          var participantName =
              ('${participant.userFirstName} ${participant.userLastName}')
                  .toLowerCase();
          var participantAlias = participant.displayName.toLowerCase();

          if (participantEmail.contains(searchQuery) ||
              participantName.contains(searchQuery) ||
              participantAlias.contains(searchQuery)) {
            _searchedParticipants.add(participant);
          }
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _futureGroups = _getGroups();

    _participantStream = _getParticipantsStream();
    _clientsStream = _getClientsStream();
    _moderatorsStream = _getModeratorsStream();

    _visibleListView = _participantsStreamBuilder(_participantStream);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Expanded(
      child: FutureBuilder<void>(
        future: _futureGroups,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Text('Loading');
              break;
            case ConnectionState.done:
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _setVisibleListView('Participants');
                                          },
                                          child: Text(
                                            'Participants',
                                            style: TextStyle(
                                              color: _participantsVisible
                                                  ? PROJECT_GREEN
                                                  : Colors.grey[700],
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _setVisibleListView('Clients');
                                          },
                                          child: Text(
                                            'Clients',
                                            style: TextStyle(
                                              color: _clientsVisible
                                                  ? PROJECT_GREEN
                                                  : Colors.grey[700],
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _setVisibleListView('Moderators');
                                          },
                                          child: Text(
                                            'Moderators',
                                            style: TextStyle(
                                              color: _moderatorsVisible
                                                  ? PROJECT_GREEN
                                                  : Colors.grey[700],
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200.0,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: TextFormField(
                                            focusNode: _searchFocusNode,
                                            cursorColor: PROJECT_NAVY_BLUE,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              hintText: 'Search',
                                              hintStyle: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showGeneralDialog(
                                                context: context,
                                                pageBuilder: (BuildContext
                                                        context,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                        secondaryAnimation) {

                                                  js.context.callMethod('setInitialValue', ['']);

                                                  return EmailWidget(
                                                    bulkSelectedParticipants: _bulkSelectedParticipants,
                                                    groupsList: _groupsList,
                                                    participantsList:
                                                        _allParticipants,
                                                  );
                                                });

                                          },
                                          child: Icon(
                                            Icons.email,
                                            color: PROJECT_GREEN,
                                            size: 24.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showGeneralDialog(
                                                context: context,
                                                pageBuilder: (BuildContext
                                                        generalDialogContext,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                        secondaryAnimation) {
                                                  return AddUsersWidget(
                                                    groups: _groupsList,
                                                    masterPassword:
                                                        _masterPassword,
                                                    generalDialogContext:
                                                        generalDialogContext,
                                                    studyUID: widget.studyUID,
                                                  );
                                                });
                                          },
                                          child: Icon(
                                            Icons.add_circle,
                                            color: PROJECT_GREEN,
                                            size: 24.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Expanded(
                              child: _visibleListView,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            color: Colors.grey[100],
                            width: screenSize.width * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Sort/Filter',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Sort By:',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Wrap(
                                  runSpacing: 10.0,
                                  spacing: 10.0,
                                  children: [
                                    ChoiceChip(
                                      elevation: 2.0,
                                      selectedColor: PROJECT_GREEN,
                                      selected: _sortBy == 'none',
                                      label: Text(
                                        'None',
                                        style: TextStyle(
                                          color: _sortBy == 'none'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _sortBy = 'none';
                                          _bulkSelectedParticipants = [];
                                          _visibleListView =
                                              _participantsStreamBuilder(
                                                  _participantStream);
                                        });
                                      },
                                    ),
                                    ChoiceChip(
                                      elevation: 2.0,
                                      selectedColor: PROJECT_GREEN,
                                      selected: _sortBy == 'mostResponses',
                                      label: Text(
                                        'Responses: High to Low',
                                        style: TextStyle(
                                          color: _sortBy == 'mostResponses'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _sortedParticipants =
                                              _allParticipants;
                                          _sortedParticipants.sort((a, b) => a
                                              .responses
                                              .compareTo(b.responses));

                                          _visibleListView =
                                              _bulkSelectListView(
                                                  _sortedParticipants);

                                          _sortBy = 'mostResponses';
                                          _filterBy = 'none';
                                        });
                                      },
                                    ),
                                    ChoiceChip(
                                      elevation: 2.0,
                                      selectedColor: PROJECT_GREEN,
                                      selected: _sortBy == 'leastResponses',
                                      label: Text(
                                        'Responses: Low to High',
                                        style: TextStyle(
                                          color: _sortBy == 'leastResponses'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _sortedParticipants =
                                              _allParticipants;
                                          _sortedParticipants.sort((a, b) => b
                                              .responses
                                              .compareTo(a.responses));

                                          _visibleListView =
                                              _bulkSelectListView(
                                                  _sortedParticipants);

                                          _sortBy = 'leastResponses';
                                          _filterBy = 'none';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Filter By:',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: [
                                    ChoiceChip(
                                      elevation: 2.0,
                                      selectedColor: PROJECT_GREEN,
                                      selected: _filterBy == 'none',
                                      label: Text(
                                        'None',
                                        style: TextStyle(
                                          color: _filterBy == 'none'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _filterBy = 'none';
                                          _bulkSelectedParticipants = [];
                                          _visibleListView =
                                              _participantsStreamBuilder(
                                                  _participantStream);
                                        });
                                      },
                                    ),
                                    ChoiceChip(
                                      elevation: 2.0,
                                      selectedColor: PROJECT_GREEN,
                                      selected: _filterBy == 'mostAnswered',
                                      label: Text(
                                        'Questions Answered: Most',
                                        style: TextStyle(
                                          color: _filterBy == 'mostAnswered'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _filterBy = 'mostAnswered';
                                          _sortBy = 'none';

                                          _filteredParticipants = _allParticipants;

                                          _filteredParticipants.sort((a, b) => a.responses.compareTo(b.responses));

                                          _visibleListView =
                                              _bulkSelectListView(
                                                  _filteredParticipants);


                                        });
                                      },
                                    ),
                                    ChoiceChip(
                                      elevation: 2.0,
                                      selectedColor: PROJECT_GREEN,
                                      selected: _filterBy == 'leastAnswered',
                                      label: Text(
                                        'Questions Answered: Least',
                                        style: TextStyle(
                                          color: _filterBy == 'leastAnswered'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onSelected: (selected) {
                                        setState(() {
                                          _filterBy = 'leastAnswered';
                                          _sortBy = 'none';

                                          _filteredParticipants = _allParticipants;

                                          _filteredParticipants.sort((a, b) => b.responses.compareTo(a.responses));

                                          _visibleListView =
                                              _bulkSelectListView(
                                                  _filteredParticipants);

                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              break;
            default:
              return Text('Error');
          }
        },
      ),
    );
  }

  Widget _bulkSelectListView(List<Participant> participants) {
    var selectedParticipants = <Participant>[];

    return ListView.separated(
      key: _listKey,
      shrinkWrap: true,
      itemCount: participants.length,
      itemBuilder: (BuildContext context, int index) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) participantBulkEditSetState) {
            return Row(
              children: [
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.grey,
                    accentColor: PROJECT_NAVY_BLUE,
                  ),
                  child: Checkbox(
                    checkColor: Colors.white,
                    onChanged: (bool selected) {
                      participantBulkEditSetState((){
                        if (selected) {
                          selectedParticipants.add(participants[index]);
                          _bulkSelectedParticipants = selectedParticipants;
                        } else {
                          _bulkSelectedParticipants.remove(participants[index]);
                          _bulkSelectedParticipants = selectedParticipants;
                        }
                      });
                    },
                    value: selectedParticipants.contains(participants[index]),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: ParticipantDetailsWidget(
                    participant: participants[index],
                    firebaseFirestoreService: widget.firebaseFirestoreService,
                    studyUID: widget.studyUID,
                  ),
                )
              ],
            );

          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10.0,
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot> _participantsStreamBuilder(
      Stream<QuerySnapshot> participantsStream) {
    _allParticipants = <Participant>[];

    return StreamBuilder<QuerySnapshot>(
      stream: participantsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            );
            break;
          case ConnectionState.active:
            return ListView.separated(
              shrinkWrap: true,
              itemCount: _groupsList.length,
              itemBuilder: (BuildContext context, int groupIndex) {
                var groupParticipants = <Participant>[];
                for (var participantDoc in snapshot.data.docs) {
                  var participant = Participant.fromMap(participantDoc.data());

                  _participantsList = <Participant>[];

                  _participantsList.add(participant);

                  if (participant.groupUID ==
                      _groupsList[groupIndex].groupUID) {
                    groupParticipants.add(participant);
                    _allParticipants.add(participant);
                  }
                }
                if (groupParticipants.isNotEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_groupsList[groupIndex].groupName}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
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
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: groupParticipants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ParticipantDetailsWidget(
                            participant: groupParticipants[index],
                            firebaseFirestoreService:
                                widget.firebaseFirestoreService,
                            studyUID: widget.studyUID,
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
                } else {
                  return SizedBox();
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 20.0,
                );
              },
            );
            break;
          case ConnectionState.done:
            return SizedBox();
            break;
          default:
            return SizedBox();
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot> _clientsStreamBuilder(
      Stream<QuerySnapshot> clientsStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: clientsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
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
            return SizedBox();
            break;
          default:
            return SizedBox();
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot> _moderatorsStreamBuilder(
      Stream<QuerySnapshot> moderatorsStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: moderatorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
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
                                        splashColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
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
            return SizedBox();
            break;
          default:
            return SizedBox();
        }
      },
    );
  }

// FutureBuilder<void> _participantsFutureBuilder(Future<void> future) {
//   return FutureBuilder<void>(
//     future: future,
//     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//       switch (snapshot.connectionState) {
//         case ConnectionState.none:
//           return Center(
//             child: Text('Some error occurred'),
//           );
//           break;
//         case ConnectionState.waiting:
//         case ConnectionState.active:
//           return Center(
//             child: Text('Loading...'),
//           );
//           break;
//         case ConnectionState.done:
//           return ListView.separated(
//             shrinkWrap: true,
//             itemCount: _groupsList.length,
//             itemBuilder: (BuildContext context, int groupIndex) {
//               var groupParticipants = <Participant>[];
//
//               for (var participant in _participantsList) {
//                 if (_groupsList[groupIndex].groupName ==
//                     participant.userGroupName) {
//                   groupParticipants.add(participant);
//                 }
//               }
//
//               if (groupParticipants.isNotEmpty) {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${_groupsList[groupIndex].groupName}',
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     Container(
//                       height: 1.0,
//                       color: Colors.grey[300],
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     ListView.separated(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: groupParticipants.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return ParticipantDetailsWidget(
//                           participant: groupParticipants[index],
//                           firebaseFirestoreService:
//                           widget.firebaseFirestoreService,
//                           studyUID: widget.studyUID,
//                         );
//                       },
//                       separatorBuilder: (BuildContext context, int index) {
//                         return SizedBox(
//                           height: 10.0,
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               } else {
//                 return SizedBox();
//               }
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return SizedBox(
//                 height: 20.0,
//               );
//             },
//           );
//           break;
//         default:
//           return Center(
//             child: Text(
//               'Some error occurred',
//             ),
//           );
//       }
//     },
//   );
// }
//
// FutureBuilder _clientsFutureBuilder() {
//   return FutureBuilder(
//     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//       switch (snapshot.connectionState) {
//         case ConnectionState.none:
//           return Center(
//             child: Text('Some error occurred'),
//           );
//           break;
//         case ConnectionState.waiting:
//         case ConnectionState.active:
//           return Center(
//             child: Text('Loading...'),
//           );
//           break;
//         case ConnectionState.done:
//           return ListView.separated(
//             itemCount: snapshot.data.length,
//             itemBuilder: (BuildContext context, int index) {
//               return SizedBox();
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return SizedBox(
//                 height: 20.0,
//               );
//             },
//           );
//           break;
//         default:
//           return Center(
//             child: Text(
//               'Some error occurred',
//             ),
//           );
//       }
//     },
//   );
// }
//
// FutureBuilder _moderatorsFutureBuilder() {
//   return FutureBuilder(
//     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//       switch (snapshot.connectionState) {
//         case ConnectionState.none:
//           return Center(
//             child: Text('Some error occurred'),
//           );
//           break;
//         case ConnectionState.waiting:
//         case ConnectionState.active:
//           return Center(
//             child: Text('Loading...'),
//           );
//           break;
//         case ConnectionState.done:
//           return ListView.separated(
//             itemCount: snapshot.data.length,
//             itemBuilder: (BuildContext context, int index) {
//               return SizedBox();
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return SizedBox(
//                 height: 20.0,
//               );
//             },
//           );
//           break;
//         default:
//           return Center(
//             child: Text(
//               'Some error occurred',
//             ),
//           );
//       }
//     },
//   );
// }

// Future<void> _addParticipantToFirebase(
//     String studyUID, Participant participant) async {
//   var user = User(
//     userEmail: participant.email,
//     userPassword: 'participant123',
//     userType: 'participant',
//     studyUID: studyUID,
//   );
//
//   var createdUser = await _firebaseFirestoreService.createUser(user);
//
//   participant.participantUID = createdUser.userUID;
//   participant.isActive = false;
//   participant.isOnboarded = false;
//   participant.isDeleted = false;
//   participant.password = 'participant123';
//
//   await _researcherAndModeratorFirestoreService.createParticipant(
//       studyUID, participant);
// }
//
// Future<void> _addClientToFirebase(String studyUID, Client client) async {
//   var user = User(
//     userEmail: client.email,
//     userPassword: 'participant123',
//     userType: 'client',
//     studyUID: studyUID,
//   );
//
//   var createdUser = await _firebaseFirestoreService.createUser(user);
//
//   client.clientUID = createdUser.userUID;
//   client.isOnboarded = false;
//   client.password = 'participant123';
//
//   await _researcherAndModeratorFirestoreService.createClient(
//       studyUID, client);
// }
//
// Future<void> _addModeratorToFirebase(
//     String studyUID, Moderator moderator) async {
//   var user = User(
//     userEmail: moderator.email,
//     userPassword: 'participant123',
//     userType: 'moderator',
//   );
//
//   var createdUser = await _firebaseFirestoreService.createUser(user);
//
//   moderator.moderatorUID = createdUser.userUID;
//   moderator.password = 'participant123';
//   moderator.assignedStudies = [];
//   moderator.assignedStudies.add(studyUID);
//
//   await _researcherAndModeratorFirestoreService.createModerator(moderator);
// }
//
// Future<void> _assignStudyToExistingModerator(
//     String studyUID, Moderator moderator) async {}

}
