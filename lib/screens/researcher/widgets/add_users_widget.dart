import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/models/user.dart';
import 'package:thoughtnav/screens/researcher/models/client.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class AddUsersWidget extends StatefulWidget {
  final String studyUID;
  final List<Group> groups;
  final BuildContext generalDialogContext;

  const AddUsersWidget(
      {Key key, this.groups, this.studyUID, this.generalDialogContext})
      : super(key: key);

  @override
  _AddUsersWidgetState createState() => _AddUsersWidgetState();
}

class _AddUsersWidgetState extends State<AddUsersWidget> {
  final _firebaseFirestoreService = FirebaseFirestoreService();
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  Widget _visiblePanel;

  String _panelType = 'participant';

  Future<void> _addParticipantToFirebase(
      String studyUID, Participant participant) async {
    var user = User(
      userEmail: participant.email,
      userPassword: 'participant123',
      userType: 'participant',
      studyUID: studyUID,
    );

    var createdUser = await _firebaseFirestoreService.createUser(user);

    participant.participantUID = createdUser.userUID;
    participant.isActive = false;
    participant.isOnboarded = false;
    participant.isDeleted = false;
    participant.password = 'participant123';

    await _researcherAndModeratorFirestoreService.createParticipant(
        studyUID, participant);
  }

  Future<void> _addClientToFirebase(String studyUID, Client client) async {
    var user = User(
      userEmail: client.email,
      userPassword: 'participant123',
      userType: 'client',
      studyUID: studyUID,
    );

    var createdUser = await _firebaseFirestoreService.createUser(user);

    client.clientUID = createdUser.userUID;
    client.isOnboarded = false;
    client.password = 'participant123';

    await _researcherAndModeratorFirestoreService.createClient(
        studyUID, client);
  }

  Widget _addParticipantPanel(BuildContext generalDialogContext) {
    var value = 0;

    var email = '';
    var firstName = '';
    var lastName = '';
    var phone = '';
    var groupUID = '';

    var participant = Participant();

    var addingParticipant = false;

    return StatefulBuilder(
      builder: (BuildContext statefulBuilderContext,
          void Function(void Function()) stateFulBuilderSetState) {
        return Center(
          child: Container(
            child: addingParticipant
                ? Material(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Adding Participant',
                      ),
                    ),
                  )
                : Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    firstName = value.trim();
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
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    lastName = value.trim();
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
                                onChanged: (value) {
                                  stateFulBuilderSetState(() {
                                    phone = value.trim();
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
                            children: List<Widget>.generate(
                                widget.groups.length, (int index) {
                              return ChoiceChip(
                                elevation: 2.0,
                                padding: EdgeInsets.all(10.0),
                                selectedColor: PROJECT_GREEN,
                                backgroundColor: Colors.grey[100],
                                label: Text(
                                  '${widget.groups[index].groupName}',
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
                                    groupUID = widget.groups[index].groupUID;
                                    participant.groupUID =
                                        widget.groups[index].groupUID;
                                    participant.userGroupName =
                                        widget.groups[index].groupName;
                                    participant.rewardAmount =
                                        widget.groups[index].groupRewardAmount;
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
  }

  Widget _addClientPanel(BuildContext generalDialogContext){
    var email = '';
    var firstName = '';
    var lastName = '';
    var phone = '';

    var client = Client();

    var addingClient = false;

    return StatefulBuilder(
      builder: (BuildContext statefulBuilderContext,
          void Function(void Function()) statefulBuilderSetState) {
        return Center(
          child: Container(
            child: addingClient
                ? Material(
              child: Padding(
                padding: EdgeInsets.all(20.0),
              ),
            )
                : Material(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            statefulBuilderSetState(() {
                              email = value.trim();
                              client.email = value.trim();
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
                            lastName != ''
                            ? () async {
                          statefulBuilderSetState(() {
                            addingClient = true;
                          });
                          await _addClientToFirebase(
                              widget.studyUID, client);
                          Navigator.of(
                              generalDialogContext)
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
        );
      },
    );

  }

  @override
  void initState() {
    _visiblePanel = _addParticipantPanel(widget.generalDialogContext);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Users',
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
              Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                children: [
                  ChoiceChip(
                    elevation: 2.0,
                    disabledColor: Colors.white,
                    selectedColor: PROJECT_GREEN,
                    padding: EdgeInsets.all(8.0),
                    onSelected: (selected) {
                      setState(() {
                        _panelType = 'participant';
                        _visiblePanel = _addParticipantPanel(widget.generalDialogContext);
                      });
                    },
                    selected: _panelType == 'participant',
                    label: Text(
                      'Add Participant',
                      style: TextStyle(
                        color: _panelType == 'participant' ? Colors.white : Colors.black,
                        fontSize: 12.0,
                        fontWeight: _panelType == 'participant' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  ChoiceChip(
                    elevation: 2.0,
                    disabledColor: Colors.white,
                    selectedColor: PROJECT_GREEN,
                    padding: EdgeInsets.all(8.0),
                    onSelected: (selected) {
                      setState(() {
                        _panelType = 'client';
                        _visiblePanel = _addClientPanel(widget.generalDialogContext);
                      });
                    },
                    selected: _panelType == 'client',
                    label: Text(
                      'Add Client',
                      style: TextStyle(
                        color: _panelType == 'client' ? Colors.white : Colors.black,
                        fontSize: 12.0,
                        fontWeight: _panelType == 'client' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  ChoiceChip(
                    elevation: 2.0,
                    disabledColor: Colors.white,
                    selectedColor: PROJECT_GREEN,
                    padding: EdgeInsets.all(8.0),
                    onSelected: (selected) {
                      setState(() {
                        _panelType = 'moderator';
                      });
                    },
                    selected: _panelType == 'moderator',
                    label: Text(
                      'Add Moderator',
                      style: TextStyle(
                        color: _panelType == 'moderator' ? Colors.white : Colors.black,
                        fontSize: 12.0,
                        fontWeight: _panelType == 'moderator' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              _visiblePanel,
            ],
          ),
        ),
      ),
    );
  }
}
