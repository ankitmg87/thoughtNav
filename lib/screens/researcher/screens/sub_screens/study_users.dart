import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/widgets/participant_details_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class StudyUsers extends StatefulWidget {
  final String studyUID;
  final FirebaseFirestoreService firebaseFirestoreService;

  const StudyUsers({Key key, this.studyUID, this.firebaseFirestoreService})
      : super(key: key);

  @override
  _StudyUsersState createState() => _StudyUsersState();
}

class _StudyUsersState extends State<StudyUsers> {
  bool _participantsVisible = true;
  bool _clientsVisible = false;
  bool _moderatorsVisible = false;

  Widget _visibleListView;

  Future<List<Participant>> _participantsFutureList;
  Future<List<Client>> _clientsFutureList;
  Future<List<Moderator>> _moderatorsFutureList;


  void _getParticipants() {
    _participantsFutureList = widget.firebaseFirestoreService.getParticipants(widget.studyUID);
  }

  void _getClients() {
    _clientsFutureList = widget.firebaseFirestoreService.getClients(widget.studyUID);
  }

  void _getModerators() {
    _moderatorsFutureList = widget.firebaseFirestoreService.getModerators(widget.studyUID);
  }

  FutureBuilder _participantsFutureBuilder() {
    return FutureBuilder(
      future: _participantsFutureList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch(snapshot.connectionState){
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
                return ParticipantDetailsWidget(
                  participant: snapshot.data[index],
                  firebaseFirestoreService: widget.firebaseFirestoreService,
                  studyUID: widget.studyUID,
                );
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
        switch(snapshot.connectionState){
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
        switch(snapshot.connectionState){
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
                return ParticipantDetailsWidget();
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

          _visibleListView = _participantsFutureBuilder();
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
    _getParticipants();
    _getClients();
    _getModerators();
    super.initState();
    _visibleListView = _participantsFutureBuilder();
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
                                  child: TextField(
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
                                Icon(
                                  Icons.edit_outlined,
                                  color: PROJECT_GREEN,
                                  size: 24.0,
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
                    color: Colors.yellow[100],
                    width: screenSize.width * 0.3,
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

class _ClientAndModeratorDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0,),
        child: Row(
          children: [],
        ),
      ),
    );
  }
}

