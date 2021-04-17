import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

import 'dart:js' as js;

class EmailWidget extends StatefulWidget {
  final List<Group> groupsList;
  final List<Participant> participantsList;
  final List<Participant> bulkSelectedParticipants;
  final String masterPassword;
  final String commonInviteMessage;

  const EmailWidget({
    Key key,
    this.groupsList,
    this.participantsList,
    this.bulkSelectedParticipants,
    this.masterPassword,
    this.commonInviteMessage,
  }) : super(key: key);

  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  String _selected;

  String _subject = '';

  bool _sendingEmail = false;

  List<Participant> _selectedParticipants = [];
  List<Group> _selectedGroups = [];

  @override
  void initState() {
    js.context.callMethod('setInitialValue', [
      '<p>${widget.commonInviteMessage}</p>'
          '<p>Link: <a href="http://bluechipdigitech.com/Thoughtnav/web/#tn_home_screen">http://bluechipdigitech.com/Thoughtnav/web/#tn_home_screen</a></p>'
          '<p>Password: ${widget.masterPassword}</p>'
    ]);

    if (widget.bulkSelectedParticipants.isEmpty) {
      _selected = 'groups';
    }

    if (widget.bulkSelectedParticipants.isNotEmpty) {
      _selected == 'bulkSelected';
    }

    super.initState();
  }

  @override
  void dispose() {
    js.context.callMethod('setInitialValue', ['']);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _sendingEmail
          ? Material(
              borderRadius: BorderRadius.circular(10.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Please Wait...',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Material(
              borderRadius: BorderRadius.circular(10.0),
              child: GestureDetector(
                onTap: () {
                  WidgetsBinding.instance.focusManager.primaryFocus.unfocus();
                },
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  padding: EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width * 0.7,
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
                      Expanded(
                        child: ListView(
                          children: [
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
                                widget.bulkSelectedParticipants.isEmpty
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          ChoiceChip(
                                            selectedColor: PROJECT_GREEN,
                                            label: Text(
                                              'Groups',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: _selected == 'groups'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight:
                                                    _selected == 'groups'
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
                                                color:
                                                    _selected == 'participants'
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight:
                                                    _selected == 'participants'
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                              ),
                                            ),
                                            selected:
                                                _selected == 'participants',
                                            onSelected: (value) {
                                              setState(
                                                () {
                                                  _selected = 'participants';
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
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
                            widget.bulkSelectedParticipants.isEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                                      selectedColor:
                                                          PROJECT_GREEN,
                                                      checkmarkColor:
                                                          Colors.white,
                                                      selected: _selectedGroups
                                                          .contains(
                                                              widget.groupsList[
                                                                  index]),
                                                      label: Text(
                                                        '${widget.groupsList[index].internalGroupLabel}',
                                                        style: TextStyle(
                                                          color: _selectedGroups
                                                                  .contains(widget
                                                                          .groupsList[
                                                                      index])
                                                              ? Colors.white
                                                              : Colors
                                                                  .grey[700],
                                                          fontWeight: _selectedGroups
                                                                  .contains(widget
                                                                          .groupsList[
                                                                      index])
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      onSelected: (bool value) {
                                                        setState(() {
                                                          if (value) {
                                                            _selectedGroups.add(
                                                                widget.groupsList[
                                                                    index]);
                                                          } else {
                                                            _selectedGroups
                                                                .removeWhere(
                                                                    (group) {
                                                              return group ==
                                                                  widget.groupsList[
                                                                      index];
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
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    widget.groupsList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var groupParticipants =
                                                      <Participant>[];

                                                  for (var participant in widget
                                                      .participantsList) {
                                                    if (widget.groupsList[index]
                                                            .groupName ==
                                                        participant
                                                            .userGroupName) {
                                                      groupParticipants
                                                          .add(participant);
                                                    }
                                                  }
                                                  if (groupParticipants
                                                      .isNotEmpty) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${widget.groupsList[index].internalGroupLabel}',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Container(
                                                          height: 1.0,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Wrap(
                                                          spacing: 10.0,
                                                          runSpacing: 10.0,
                                                          children: List.generate(
                                                              groupParticipants
                                                                  .length,
                                                              (chipIndex) {
                                                            return FilterChip(
                                                              selectedColor:
                                                                  PROJECT_GREEN,
                                                              checkmarkColor:
                                                                  Colors.white,
                                                              selected: _selectedParticipants
                                                                  .contains(
                                                                      groupParticipants[
                                                                          chipIndex]),
                                                              label: Text(
                                                                '${groupParticipants[chipIndex].userFirstName} ${groupParticipants[chipIndex].userLastName}',
                                                                style:
                                                                    TextStyle(
                                                                  color: _selectedParticipants.contains(
                                                                          groupParticipants[
                                                                              chipIndex])
                                                                      ? Colors
                                                                          .white
                                                                      : Colors.grey[
                                                                          700],
                                                                  fontWeight: _selectedParticipants.contains(
                                                                          groupParticipants[
                                                                              chipIndex])
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .normal,
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                              onSelected:
                                                                  (bool value) {
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
                                                    (BuildContext context,
                                                        int index) {
                                                  return SizedBox(
                                                    height: 10.0,
                                                  );
                                                },
                                              ),
                                            ),
                                    ],
                                  )
                                : Wrap(
                                    runSpacing: 10.0,
                                    spacing: 10.0,
                                    children: List.generate(
                                        widget.bulkSelectedParticipants.length,
                                        (participantIndex) {
                                      return FilterChip(
                                        selectedColor: PROJECT_GREEN,
                                        checkmarkColor: Colors.white,
                                        selected:
                                            _selectedParticipants.contains(
                                                widget.bulkSelectedParticipants[
                                                    participantIndex]),
                                        label: Text(
                                          '${widget.bulkSelectedParticipants[participantIndex].userFirstName}'
                                          ' ${widget.bulkSelectedParticipants[participantIndex].userLastName}',
                                          style: TextStyle(
                                            color: _selectedParticipants.contains(
                                                    widget.bulkSelectedParticipants[
                                                        participantIndex])
                                                ? Colors.white
                                                : Colors.grey[700],
                                            fontWeight: _selectedParticipants
                                                    .contains(widget
                                                            .bulkSelectedParticipants[
                                                        participantIndex])
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        onSelected: (bool value) {
                                          setState(() {
                                            if (value) {
                                              _selectedParticipants.add(widget
                                                      .bulkSelectedParticipants[
                                                  participantIndex]);
                                            } else {
                                              _selectedParticipants
                                                  .removeWhere((participant) {
                                                return participant ==
                                                    widget.bulkSelectedParticipants[
                                                        participantIndex];
                                              });
                                            }
                                          });
                                        },
                                      );
                                    }),
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
                            TextFormField(
                              onChanged: (subject) {
                                _subject = subject;
                              },
                              decoration: InputDecoration(
                                hintText: 'Subject',
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
                            EasyWebView(
                              src: 'quill.html',
                              onLoaded: () {},
                              height: 400,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
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
                            onPressed: () async {
                              var message =
                                  js.context.callMethod('readLocalStorage');
                              var extractedMessage = message.toString();
                              var sanitisedMessage = extractedMessage
                                  .replaceAll('<p><br></p>', ' ');
                              print(sanitisedMessage);
                              if (widget.bulkSelectedParticipants.isNotEmpty) {
                                if (_selectedParticipants.isNotEmpty) {
                                  setState(() {
                                    _sendingEmail = true;
                                  });
                                  for (var participant
                                      in _selectedParticipants) {
                                    setState(() {
                                      _sendingEmail = true;
                                    });
                                    try {
                                      await _researcherAndModeratorFirestoreService
                                          .sendEmail(
                                              participant.email,
                                              sanitisedMessage,
                                              'Mike Courtney',
                                              _subject);
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                  setState(() {
                                    _sendingEmail = false;
                                  });
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                if (_selected == 'groups') {
                                  _selectedParticipants = [];
                                  for (var selectedGroup in _selectedGroups) {
                                    for (var participant
                                        in widget.participantsList) {
                                      if (selectedGroup.groupUID ==
                                          participant.groupUID) {
                                        _selectedParticipants.add(participant);
                                      }
                                    }
                                  }
                                  if (_selectedParticipants.isNotEmpty) {
                                    setState(() {
                                      _sendingEmail = true;
                                    });
                                    for (var participant
                                        in _selectedParticipants) {
                                      try {
                                        await _researcherAndModeratorFirestoreService
                                            .sendEmail(
                                                participant.email,
                                                sanitisedMessage,
                                                'Mike Courtney',
                                                _subject);
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    setState(() {
                                      _sendingEmail = false;
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                }
                                if (_selected == 'participants') {
                                  if (_selectedParticipants.isNotEmpty) {
                                    setState(() {
                                      _sendingEmail = true;
                                    });
                                    for (var participant
                                        in _selectedParticipants) {
                                      setState(() {
                                        _sendingEmail = true;
                                      });
                                      try {
                                        await _researcherAndModeratorFirestoreService
                                            .sendEmail(
                                                participant.email,
                                                sanitisedMessage,
                                                'Mike Courtney',
                                                _subject);
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    setState(() {
                                      _sendingEmail = false;
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                }
                                Navigator.of(context).pop();
                              }
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
