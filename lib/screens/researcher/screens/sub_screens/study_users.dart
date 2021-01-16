import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/widgets/participant_details_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class StudyUsers extends StatefulWidget {
  final String studyUID;
  final FirebaseFirestoreService firebaseFirestoreService;

  const StudyUsers({Key key, this.studyUID, this.firebaseFirestoreService})
      : super(key: key);

  @override
  _StudyUsersState createState() => _StudyUsersState();
}

class _StudyUsersState extends State<StudyUsers> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  bool _participantsVisible = true;
  bool _clientsVisible = false;
  bool _moderatorsVisible = false;

  bool _multiSelect = false;

  Widget _visibleListView;

  List<Group> _groupsList;

  String _sortBy = 'none';
  String _filterBy = 'none';

  // Future<List<Participant>> _participantsFutureList;
  Future<List<Client>> _clientsFutureList;
  Future<List<Moderator>> _moderatorsFutureList;

  List<Participant> _participantsList = [];
  List<Participant> _bulkSelectedParticipants = [];
  List<Participant> _sortedParticipants = [];
  List<Participant> _filteredParticipants = [];

  Future<void> _getFutureParticipants() async {
    _groupsList = await _researcherAndModeratorFirestoreService
        .getGroups(widget.studyUID);
    _participantsList = await _researcherAndModeratorFirestoreService
        .getParticipants(widget.studyUID);
  }

  void _getClients() {
    _clientsFutureList =
        widget.firebaseFirestoreService.getClients(widget.studyUID);
  }

  void _getModerators() {
    _moderatorsFutureList =
        widget.firebaseFirestoreService.getModerators(widget.studyUID);
  }

  void _setMultiSelectMode() {
    setState(() {
      _multiSelect = !_multiSelect;
    });
  }

  FutureBuilder<void> _participantsFutureBuilder(Future<void> future) {
    return FutureBuilder<void>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('Some error occurred'),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text('Loading...'),
            );
            break;
          case ConnectionState.done:
            return ListView.separated(
              shrinkWrap: true,
              itemCount: _groupsList.length,
              itemBuilder: (BuildContext context, int groupIndex) {
                var groupParticipants = <Participant>[];

                for (var participant in _participantsList) {
                  if (_groupsList[groupIndex].groupName ==
                      participant.userGroupName) {
                    groupParticipants.add(participant);
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
          default:
            return Center(
              child: Text(
                'Some error occurred',
              ),
            );
        }
      },
    );
  }

  FutureBuilder _clientsFutureBuilder() {
    return FutureBuilder(
      future: _clientsFutureList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('Some error occurred'),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text('Loading...'),
            );
            break;
          case ConnectionState.done:
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox();
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 20.0,
                );
              },
            );
            break;
          default:
            return Center(
              child: Text(
                'Some error occurred',
              ),
            );
        }
      },
    );
  }

  FutureBuilder _moderatorsFutureBuilder() {
    return FutureBuilder(
      future: _moderatorsFutureList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('Some error occurred'),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text('Loading...'),
            );
            break;
          case ConnectionState.done:
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox();
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 20.0,
                );
              },
            );
            break;
          default:
            return Center(
              child: Text(
                'Some error occurred',
              ),
            );
        }
      },
    );
  }

  void _setVisibleListView(String label) {
    switch (label) {
      case 'Participants':
        setState(() {
          _participantsVisible = true;
          _clientsVisible = false;
          _moderatorsVisible = false;

          _visibleListView =
              _participantsFutureBuilder(_getFutureParticipants());
        });
        break;
      case 'Clients':
        setState(() {
          _participantsVisible = false;
          _clientsVisible = true;
          _moderatorsVisible = false;

          _visibleListView = _clientsFutureBuilder();
        });
        break;
      case 'Moderators':
        setState(() {
          _participantsVisible = false;
          _clientsVisible = false;
          _moderatorsVisible = true;

          _visibleListView = _moderatorsFutureBuilder();
        });
        break;
    }
  }

  @override
  void initState() {
    // _getGroups();
    _getClients();
    _getModerators();
    super.initState();
    _visibleListView = _participantsFutureBuilder(_getFutureParticipants());
  }



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Expanded(
      child: Padding(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200.0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: TextFormField(
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
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return EmailWidget(
                                            groupsList: _groupsList,
                                            participantsList: _participantsList,
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.email,
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
                                  color: _sortBy == 'none' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              onSelected: (selected){
                                setState(() {
                                  _sortBy = 'none';
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
                                  color: _sortBy == 'mostResponses' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              onSelected: (selected){
                                setState(() {
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
                                  color: _sortBy == 'leastResponses' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              onSelected: (selected){
                                setState(() {
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
                                  color: _filterBy == 'none' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              onSelected: (selected){
                                setState(() {
                                  _filterBy = 'none';
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
                                  color: _filterBy == 'mostAnswered' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              onSelected: (selected){
                                setState(() {
                                  _filterBy = 'mostAnswered';
                                  _sortBy = 'none';
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
                                  color: _filterBy == 'leastAnswered' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              onSelected: (selected){
                                setState(() {
                                  _filterBy = 'leastAnswered';
                                  _sortBy = 'none';
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
      ),
    );
  }
}

class EmailWidget extends StatefulWidget {
  final List<Group> groupsList;
  final List<Participant> participantsList;

  const EmailWidget({
    Key key,
    this.groupsList,
    this.participantsList,
  }) : super(key: key);

  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  String _selected = 'groups';

  List<Participant> _selectedParticipants = [];
  List<Group> _selectedGroups = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Compose',
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
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Text(
                    'Send Email To: ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  ChoiceChip(
                    selectedColor: PROJECT_GREEN,
                    label: Text(
                      'Groups',
                      style: TextStyle(
                        fontSize: 12.0,
                        color:
                            _selected == 'groups' ? Colors.white : Colors.black,
                        fontWeight: _selected == 'groups'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: _selected == 'groups',
                    onSelected: (value) {
                      setState(() {
                        _selected = 'groups';
                      });
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  ChoiceChip(
                    selectedColor: PROJECT_GREEN,
                    label: Text(
                      'Participants',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: _selected == 'participants'
                            ? Colors.white
                            : Colors.black,
                        fontWeight: _selected == 'participants'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: _selected == 'participants',
                    onSelected: (value) {
                      setState(() {
                        _selected = 'participants';
                      });
                    },
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
              Expanded(
                child: ListView(
                  children: [
                    _selected == 'groups'
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: List.generate(
                                widget.groupsList.length,
                                (index) {
                                  return FilterChip(
                                    selectedColor: PROJECT_GREEN,
                                    checkmarkColor: Colors.white,
                                    selected: _selectedGroups
                                        .contains(widget.groupsList[index]),
                                    label: Text(
                                      '${widget.groupsList[index].groupName}',
                                      style: TextStyle(
                                        color: _selectedGroups.contains(
                                                widget.groupsList[index])
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: _selectedGroups.contains(
                                                widget.groupsList[index])
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    onSelected: (bool value) {
                                      setState(() {
                                        if (value) {
                                          _selectedGroups
                                              .add(widget.groupsList[index]);
                                        } else {
                                          _selectedGroups.removeWhere((group) {
                                            return group ==
                                                widget.groupsList[index];
                                          });
                                        }
                                      });
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.groupsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var groupParticipants = <Participant>[];

                                for (var participant
                                    in widget.participantsList) {
                                  if (widget.groupsList[index].groupName ==
                                      participant.userGroupName) {
                                    groupParticipants.add(participant);
                                  }
                                }

                                if (groupParticipants.isNotEmpty) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.groupsList[index].groupName}',
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
                                        height: 10.0,
                                      ),
                                      Wrap(
                                        children: List.generate(
                                            groupParticipants.length,
                                            (chipIndex) {
                                          return FilterChip(
                                            selectedColor: PROJECT_GREEN,
                                            checkmarkColor: Colors.white,
                                            selected: _selectedParticipants
                                                .contains(groupParticipants[
                                                    chipIndex]),
                                            label: Text(
                                              '${groupParticipants[chipIndex].userFirstName} ${groupParticipants[chipIndex].userLastName}',
                                              style: TextStyle(
                                                color: _selectedParticipants
                                                        .contains(
                                                            groupParticipants[
                                                                chipIndex])
                                                    ? Colors.white
                                                    : Colors.grey[700],
                                                fontWeight: _selectedParticipants
                                                        .contains(
                                                            groupParticipants[
                                                                chipIndex])
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            onSelected: (bool value) {
                                              setState(() {
                                                if (value) {
                                                  _selectedParticipants.add(
                                                      groupParticipants[
                                                          chipIndex]);
                                                } else {
                                                  _selectedParticipants
                                                      .removeWhere(
                                                          (participant) {
                                                    return participant ==
                                                        groupParticipants[
                                                            chipIndex];
                                                  });
                                                }
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 10.0,
                                );
                              },
                            ),
                          ),
                  ],
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
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    color: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  RaisedButton(
                    color: PROJECT_GREEN,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
