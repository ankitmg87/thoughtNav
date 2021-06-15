// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/questions_widgets/question_and_description_container.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/participant_response_field.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/user_response_widget.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

class ParticipantSmartphoneResponsesScreen extends StatefulWidget {
  final String studyName;
  final String studyUID;
  final Participant participant;
  final String topicUID;
  final String questionUID;

  const ParticipantSmartphoneResponsesScreen(
      {Key key,
      this.studyUID,
      this.participant,
      this.topicUID,
      this.questionUID,
      this.studyName})
      : super(key: key);

  @override
  _ParticipantSmartphoneResponsesScreenState createState() =>
      _ParticipantSmartphoneResponsesScreenState();
}

class _ParticipantSmartphoneResponsesScreenState
    extends State<ParticipantSmartphoneResponsesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _participantFirestoreService = ParticipantFirestoreService();

  bool _participantResponded = false;

  String _topicUID;
  String _questionUID;

  String _nextQuestionUID;
  String _nextTopicUID;

  Question _question;

  List<Topic> _studyNavigatorTopics;

  TextEditingController _responseController;

  Future<List<Topic>> _futureTopics;
  Future<Question> _futureQuestion;
  Future<Response> _participantResponse;

  Stream<DocumentSnapshot> _questionStream;
  Stream<QuerySnapshot> _responsesStream;

  Future<List<Topic>> _getTopics(
      String studyUID, String participantGroupUID) async {
    _studyNavigatorTopics = await _participantFirestoreService
        .getParticipantTopics(studyUID, participantGroupUID);

    _setNextQuestionUIDAndNextTopicUID();

    return _studyNavigatorTopics;
  }

  Future<Question> _getQuestion(String topicUID, String questionUID) async {
    _question = await _participantFirestoreService.getQuestion(
        widget.studyUID, topicUID, questionUID);

    await _getTopics(widget.studyUID, widget.participant.groupUID);

    if (_question.respondedBy != null) {
      if (_question.respondedBy.contains(widget.participant.participantUID)) {
        _participantResponded = true;
      } else {
        _participantResponded = false;
      }
    } else {
      _participantResponded = false;
    }
    return _question;
  }

  Stream<QuerySnapshot> _getResponsesStream(
      String studyUID, String topicUID, String questionUID) {
    return _participantFirestoreService.getResponses(
        studyUID, topicUID, questionUID);
  }

  Stream<DocumentSnapshot> _getQuestionStream(String studyUID, String topicUID,
      String questionUID, String participantUID) {
    return _participantFirestoreService.streamRespondedBy(
        studyUID, topicUID, questionUID, participantUID);
  }

  void _unAwaited(Future<void> future) {}

  void _setNextQuestionUIDAndNextTopicUID() {
    var topicIndex = _studyNavigatorTopics.indexWhere((topic) {
      if (topic.topicUID == _topicUID) {
        var questionIndex = topic.questions.indexWhere((question) {
          return question.questionUID == _questionUID;
        });
        if (questionIndex != -1) {
          if (topic.questions.length - 1 >= questionIndex + 1 &&
              topic.questions[questionIndex].questionTimestamp
                  .millisecondsSinceEpoch <
                  Timestamp.now().millisecondsSinceEpoch) {
            _nextQuestionUID = topic.questions[questionIndex + 1].questionUID;
            _nextTopicUID = topic.topicUID;
          } else {
            _nextQuestionUID = 'lastQuestionInThisTopic';
          }
        }
        return true;
      } else {
        return false;
      }
    });
    if (_nextQuestionUID == 'lastQuestionInThisTopic') {
      if (topicIndex != -1) {
        if (_studyNavigatorTopics.length - 1 >= topicIndex + 1) {
          if (_studyNavigatorTopics[topicIndex + 1].topicDate.millisecondsSinceEpoch <= Timestamp.now().millisecondsSinceEpoch) {
            _nextTopicUID = _studyNavigatorTopics[topicIndex + 1].topicUID;
            _nextQuestionUID = _studyNavigatorTopics[topicIndex + 1]
                .questions
                .first
                .questionUID;
          } else {
            _nextTopicUID = 'lastTopicInThisStudy';
          }
        } else {
          _nextTopicUID = 'lastTopicInThisStudy';
        }
      }
    }
  }

  void _continueToNextQuestion(String nextTopicUID, String nextQuestionUID) {
    setState(() {
      _topicUID = nextTopicUID;
      _questionUID = nextQuestionUID;
      _futureTopics = _getTopics(widget.studyUID, widget.participant.groupUID);
      _futureQuestion = _getQuestion(nextTopicUID, nextQuestionUID);
      _questionStream = _getQuestionStream(widget.studyUID, nextTopicUID,
          nextQuestionUID, widget.participant.participantUID);
      _responsesStream =
          _getResponsesStream(widget.studyUID, nextTopicUID, nextQuestionUID);
    });
  }

  Widget _participantResponseWidget(Question question) {
    if (question.respondedBy.contains(widget.participant.participantUID)) {
      if (question.questionType != 'Private') {
        return Text(
          'Your response has been posted.\n'
              'Please read and comment on other posts.\n'
              'Scroll to the bottom to continue',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return SizedBox();
      }
    } else {
      _responseController = TextEditingController();

      var response = Response(
        questionHasMedia: question.allowImage || question.allowVideo,
      );

      return ParticipantResponseField(
        studyName: widget.studyName,
        participant: widget.participant,
        question: question,
        topicUID: _topicUID,
        responseController: _responseController,
        response: response,
        onTap: () async {
          response.responseUID = '';
          response.questionNumber = question.questionNumber;
          response.questionTitle = question.questionTitle;
          response.participantUID = widget.participant.participantUID;
          response.participantGroupUID = widget.participant.groupUID;
          response.participantDisplayName = widget.participant.displayName;
          response.avatarURL = widget.participant.profilePhotoURL;
          response.claps = [];
          response.comments = 0;
          response.hasMedia ??= false;
          response.userName =
          '${widget.participant.userFirstName} ${widget.participant.userLastName}';
          response.responseTimestamp = Timestamp.now();
          response.participantDeleted = false;

          setState(() {
            _responseController = null;
            _question.respondedBy.add(widget.participant.participantUID);
          });

          await _participantFirestoreService.postResponse(widget.studyUID,
              widget.participant.participantUID, _topicUID, question.questionUID, response);

          setState(() {
            _futureTopics = _getTopics(
                widget.studyUID,
                widget.participant.groupUID);
          });
        },
      );
    }
  }

  @override
  void initState() {
    _topicUID = widget.topicUID;
    _questionUID = widget.questionUID;

    _futureTopics = _getTopics(widget.studyUID, widget.participant.groupUID);
    _futureQuestion = _getQuestion(_topicUID, _questionUID);
    _questionStream = _getQuestionStream(widget.studyUID, _topicUID,
        _questionUID, widget.participant.participantUID);
    _responsesStream =
        _getResponsesStream(widget.studyUID, _topicUID, _questionUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_responseController == null) {
          _unAwaited(Navigator.of(context)
              .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN));
          return true;
        }
        if (_responseController != null) {
          if (_responseController.text.isNotEmpty) {
            await showGeneralDialog(
                barrierDismissible: false,
                barrierLabel: 'Are you sure',
                context: context,
                pageBuilder: (BuildContext exitDialogContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confirm Exit',
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Align(
                                child: Container(
                                  height: 1.0,
                                  width: double.maxFinite,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                'The response which has\'nt been posted will be lost.',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(exitDialogContext).pop();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    RaisedButton(
                                      color: Colors.red[700],
                                      onPressed: () {
                                        Navigator.of(exitDialogContext)
                                            .pushNamedAndRemoveUntil(
                                                PARTICIPANT_DASHBOARD_SCREEN,
                                                (route) => false);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'EXIT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
            return false;
          } else {
            _unAwaited(Navigator.of(context)
                .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN));
            return true;
          }
        }
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        endDrawer: _buildEndDrawer(),
        body: FutureBuilder(
          future: _futureQuestion,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text('Something went wrong'),
                );
                break;
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: Text('Loading...'),
                );
                break;
              case ConnectionState.done:
                return Scrollbar(
                  isAlwaysShown: true,
                  thickness: 10.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 10.0,
                          color: PROJECT_GREEN.withOpacity(0.2),
                        ),
                        QuestionAndDescriptionContainer(
                          screenSize: MediaQuery.of(context).size,
                          number: _question.questionNumber,
                          title: _question.questionTitle,
                          description: _question.questionStatement,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        _participantResponseWidget(_question),
                        SizedBox(
                          height: 20.0,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _responsesStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return SizedBox();
                                break;
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                                if (snapshot.hasData) {
                                  if (_question.questionType == 'Standard') {
                                    var responses = snapshot.data.docs;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 1.0,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                'All Responses',
                                                style: TextStyle(
                                                  color: PROJECT_NAVY_BLUE,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: responses.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            var response = Response.fromMap(
                                                responses[index].data());

                                            if (responses[index]['responseUID'] !=
                                                null) {
                                              try {
                                                return UserResponseWidget(
                                                  participant: widget.participant,
                                                  topicUID: _topicUID,
                                                  question: _question,
                                                  response: response,
                                                );
                                              } catch (e) {
                                                print(e);
                                                return SizedBox();
                                              }
                                            } else {
                                              return SizedBox();
                                            }
                                          },
                                        )
                                      ],
                                    );
                                  } else if (_question.questionType ==
                                      'Uninfluenced') {
                                    if (_participantResponded) {
                                      var responses = snapshot.data.docs;
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 1.0,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  'All Responses',
                                                  style: TextStyle(
                                                    color: PROJECT_NAVY_BLUE,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: responses.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var response = Response.fromMap(
                                                  responses[index].data());

                                              if (responses[index]
                                                      ['responseUID'] !=
                                                  null) {
                                                try {
                                                  return UserResponseWidget(
                                                    participant:
                                                        widget.participant,
                                                    topicUID: _topicUID,
                                                    question: _question,
                                                    response: response,
                                                  );
                                                } catch (e) {
                                                  print(e);
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          )
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  } else {
                                    if (_participantResponded) {
                                      var responses = snapshot.data.docs;
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 1.0,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  'Your Response',
                                                  style: TextStyle(
                                                    color: PROJECT_NAVY_BLUE,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: responses.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var response = Response.fromMap(
                                                  responses[index].data());

                                              if (response.participantUID ==
                                                  widget.participant
                                                      .participantUID) {
                                                return UserResponseWidget(
                                                  participant: widget.participant,
                                                  topicUID: _topicUID,
                                                  question: _question,
                                                  response: response,
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          )
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  }
                                } else if (snapshot.data == null) {
                                  return Center(
                                    child: Text('No responses yet'),
                                  );
                                } else {
                                  return Center(
                                    child: Text('No responses yet'),
                                  );
                                }
                                break;
                              case ConnectionState.done:
                              default:
                                return Center(
                                  child: Text('No responses yet'),
                                );
                            }
                          },
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        _participantResponded
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      if (_nextTopicUID ==
                                          'lastTopicInThisStudy') {
                                        Navigator.of(context).popAndPushNamed(
                                            PARTICIPANT_DASHBOARD_SCREEN);
                                      } else {
                                        _continueToNextQuestion(
                                            _nextTopicUID, _nextQuestionUID);
                                      }
                                    },
                                    color: PROJECT_GREEN,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 12.0,
                                      ),
                                      child: Text(
                                        'CONTINUE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                );
                break;
              default:
                return SizedBox();
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () async {
          if (_responseController == null) {
            _unAwaited(Navigator.of(context)
                .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN));
          }

          if (_responseController != null) {
            if (_responseController.text.isNotEmpty) {
              await showGeneralDialog(
                  barrierDismissible: false,
                  barrierLabel: 'Are you sure',
                  context: context,
                  pageBuilder: (BuildContext exitDialogContext,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm Exit',
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Align(
                                  child: Container(
                                    height: 1.0,
                                    width: double.maxFinite,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  'The response which has\'nt been posted will be lost.',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(exitDialogContext).pop();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      RaisedButton(
                                        color: Colors.red[700],
                                        onPressed: () {
                                          Navigator.of(exitDialogContext)
                                              .pushNamedAndRemoveUntil(
                                                  PARTICIPANT_DASHBOARD_SCREEN,
                                                  (route) => false);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'EXIT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              _unAwaited(Navigator.of(context)
                  .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN));
            }
          }
          // Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
        },
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
        ),
      ),
      title: Text(
        'Responses',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openEndDrawer();
          },
        ),
      ],
    );
  }

  AlertDialog _buildAlertDialog() {
    return AlertDialog();
  }

  Widget _buildEndDrawer() {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Study Navigator',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1.0,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: FutureBuilder<List<Topic>>(
              future: _futureTopics,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Topic>> topicsSnapshot) {
                switch (topicsSnapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return SizedBox();
                    break;
                  case ConnectionState.done:
                    if (topicsSnapshot.hasData) {
                      if (topicsSnapshot.data.isNotEmpty) {

                        var topics = <Topic>[];

                        for (var topicSnapshot in topicsSnapshot.data) {
                          topics.add(
                            Topic(
                              topicUID: topicSnapshot.topicUID,
                              topicDate: topicSnapshot.topicDate,
                              topicName: topicSnapshot.topicName,
                              topicNumber: topicSnapshot.topicNumber,
                              questions: topicSnapshot.questions,
                            ),
                          );
                        }

                        return Scrollbar(
                          isAlwaysShown: true,
                          thickness: 10.0,
                          child: ListView.separated(
                            padding: EdgeInsets.only(right: 15.0),
                            itemCount: topics.length,
                            itemBuilder:
                                (BuildContext context, int topicIndex) {
                              if (topicIndex == 0) {
                                return _buildStudyNavigatorActiveTopicExpansionTile(
                                    topics[topicIndex]);
                              } else {
                                if (topics[topicIndex - 1]
                                    .questions
                                    .last
                                    .isProbe && topics[topicIndex].topicDate.millisecondsSinceEpoch <= Timestamp.now().millisecondsSinceEpoch) {
                                  return _buildStudyNavigatorActiveTopicExpansionTile(
                                      topics[topicIndex]);
                                } else if (topics[topicIndex - 1]
                                    .questions
                                    .last
                                    .respondedBy !=
                                    null) {
                                  if (topics[topicIndex - 1]
                                      .questions
                                      .last
                                      .respondedBy
                                      .contains(widget
                                      .participant.participantUID) &&
                                      topics[topicIndex]
                                          .topicDate
                                          .millisecondsSinceEpoch <=
                                          Timestamp.now()
                                              .millisecondsSinceEpoch  && topics[topicIndex].topicDate.millisecondsSinceEpoch <= Timestamp.now().millisecondsSinceEpoch) {
                                    return _buildStudyNavigatorActiveTopicExpansionTile(
                                        topics[topicIndex]);
                                  } else {
                                    return _buildStudyNavigatorLockedTopicListTile(
                                        topics[topicIndex]);
                                  }
                                } else {
                                  return _buildStudyNavigatorLockedTopicListTile(
                                      topics[topicIndex]);
                                }
                              }
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox();
                            },
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return SizedBox();
                    }
                    break;
                  default:
                    return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyNavigatorActiveQuestion(
      Question question, String topicUID) {
    return InkWell(
      onTap: () async {
        if (_responseController == null) {
          setState(() {
            _topicUID = topicUID;
            _questionUID = question.questionUID;
            _futureQuestion = _getQuestion(topicUID, question.questionUID);
            _responsesStream = _getResponsesStream(
                widget.studyUID, topicUID, question.questionUID);
          });
        }
        if (_responseController != null) {
          if (_responseController.text.isNotEmpty) {
            await showGeneralDialog(
                barrierDismissible: false,
                barrierLabel: 'Are you sure',
                context: context,
                pageBuilder: (BuildContext exitDialogContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Center(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.3),
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Align(
                                child: Container(
                                  height: 1.0,
                                  width: double.maxFinite,
                                  color: Colors.grey,
                                  constraints: BoxConstraints(
                                    maxWidth:
                                    MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                'The response which has\'nt been posted will be lost.',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(exitDialogContext).pop();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    RaisedButton(
                                      color: Colors.red[700],
                                      onPressed: () {
                                        Navigator.of(exitDialogContext).pop();
                                        setState(() {
                                          _topicUID = topicUID;
                                          _questionUID = question.questionUID;
                                          _futureQuestion = _getQuestion(
                                              topicUID, question.questionUID);
                                          _responsesStream =
                                              _getResponsesStream(
                                                  widget.studyUID,
                                                  topicUID,
                                                  question.questionUID);
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'EXIT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          else {
            setState(() {
              _topicUID = topicUID;
              _questionUID = question.questionUID;
              _futureQuestion = _getQuestion(topicUID, question.questionUID);
              _responsesStream = _getResponsesStream(
                  widget.studyUID, topicUID, question.questionUID);
            });
          }
        }
      },
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${question.questionNumber}  ${question.questionTitle}',
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
            Icon(
              question.respondedBy == null
                  ? Icons.arrow_forward
                  : question.respondedBy
                          .contains(widget.participant.participantUID)
                      ? Icons.check_circle_outline_rounded
                      : Icons.arrow_forward,
              color: PROJECT_GREEN,
              size: 14.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyNavigatorLockedQuestion(Question question) {
    return InkWell(
      onTap: () {
        showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: 'Respond to questions',
            context: context,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Please respond to previous questions',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '${question.questionNumber}  Question Locked',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.lock,
              color: Colors.grey[800],
              size: 13.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyNavigatorActiveTopicExpansionTile(Topic topic) {
    return Theme(
      data: ThemeData(
          unselectedWidgetColor: Colors.black, accentColor: PROJECT_GREEN),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          topic.topicName,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        children: [
          SizedBox(
            height: 10.0,
          ),
          ListView.separated(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 10.0,
            ),
            shrinkWrap: true,
            itemCount: topic.questions.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int questionIndex) {
              if (questionIndex == 0 &&
                  topic.questions[questionIndex].questionTimestamp
                      .millisecondsSinceEpoch <
                      Timestamp.now().millisecondsSinceEpoch) {
                return _buildStudyNavigatorActiveQuestion(
                    topic.questions[questionIndex], topic.topicUID);
              } else {
                if (topic.questions[questionIndex - 1].respondedBy != null) {
                  if (topic.questions[questionIndex - 1].respondedBy
                      .contains(widget.participant.participantUID) ||
                      topic.questions[questionIndex].isProbe) {
                    if (topic.questions[questionIndex].questionTimestamp
                        .millisecondsSinceEpoch <
                        Timestamp.now().millisecondsSinceEpoch) {
                      return _buildStudyNavigatorActiveQuestion(
                          topic.questions[questionIndex], topic.topicUID);
                    } else {
                      return _buildStudyNavigatorLockedQuestion(
                          topic.questions[questionIndex]);
                    }
                  } else {
                    return _buildStudyNavigatorLockedQuestion(
                        topic.questions[questionIndex]);
                  }
                } else {
                  return _buildStudyNavigatorLockedQuestion(
                      topic.questions[questionIndex]);
                }
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20.0);
            },
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _buildStudyNavigatorLockedTopicListTile(Topic topic) {
    return ListTile(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierLabel: 'Locked Topic Dialog',
          barrierDismissible: true,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Center(
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'All Previous questions must be answered',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      title: Text(
        'Topic Locked',
      ),
    );
  }
}
