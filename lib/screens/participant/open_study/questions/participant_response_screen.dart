import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:image_whisperer/image_whisperer.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/end_drawer_expansion_tile.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/questions_widgets/question_and_description_container.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/comment_widget.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';
import 'package:thoughtnav/services/participant_storage_service.dart';
import 'package:video_player/video_player.dart';

import 'quick_intro_tutorial/quick_intro_tutorial_widgets/user_post_widget.dart';

class ParticipantResponseScreen extends StatefulWidget {
  @override
  _ParticipantResponseScreenState createState() =>
      _ParticipantResponseScreenState();
}

class _ParticipantResponseScreenState extends State<ParticipantResponseScreen> {
  final GlobalKey<ScaffoldState> _participantResponseScreenScaffoldKey =
      GlobalKey<ScaffoldState>();

  final _firebaseFirestoreService = FirebaseFirestoreService();

  final _participantFirestoreService = ParticipantFirestoreService();

  final _participantStorageService = ParticipantStorageService();

  String _studyUID;
  String _participantUID;
  String _topicUID;
  String _questionUID;
  String _studyName;

  String _nextTopicUID;
  String _nextQuestionUID;

  double value = 40.5;
  double minMenuWidth = 40.5;
  double maxMenuWidth = 300.0;
  double studyNavigatorWidth;

  bool isExpanded = false;
  bool showDrawer = false;

  bool _questionAnswered = false;
  bool _responseEditable = false;

  Participant _participant;
  Question _question;
  Response _response = Response();
  Comment _comment = Comment();

  List<Topic> _studyNavigatorTopics;

  Future<void> _futureParticipant;
  Future<void> _futureStudyNavigatorTopics;
  Future<void> _futureQuestion;

  Stream<QuerySnapshot> _responsesStream;

  final _participantResponseController = TextEditingController();

  void _toggleResponseEditing() {
    setState(() {
      _responseEditable = !_responseEditable;
    });
  }

  Future<void> _getStudyNavigatorTopics(String studyUID) async {
    _studyNavigatorTopics = await _participantFirestoreService
        .getParticipantTopics(_studyUID, _participant.groupUID);
  }

  Future<void> _getParticipant(String studyUID, String participantUID) async {
    _participant = await _firebaseFirestoreService.getParticipant(
        studyUID, participantUID);

    _futureStudyNavigatorTopics = _getStudyNavigatorTopics(_studyUID);
  }

  Future<void> _getQuestion(String topicUID, String questionUID) async {
    _getParticipantResponse(_studyUID, topicUID, questionUID, _participantUID);

    _question = await _firebaseFirestoreService.getQuestion(
        _studyUID, topicUID, questionUID);
  }

  Stream<QuerySnapshot> _getResponsesStream(
      String studyUID, String topicUID, String questionUID) {
    return _firebaseFirestoreService.getResponsesAsStream(
        studyUID, topicUID, questionUID);
  }

  Stream<QuerySnapshot> _getCommentsStream(String studyUID, String topicUID,
      String questionUID, String responseUID) {
    return _firebaseFirestoreService.getCommentsAsStream(
        studyUID, topicUID, questionUID, responseUID);
  }

  Future<void> _postResponse(
      String topicUID, String questionUID, Response response) async {
    if (_response.hasMedia) {
      if (_response.mediaType == 'image') {
        var imageUri = await _participantStorageService.uploadImageToFirebase(
            _studyName, _participantUID, _response.media);

        _response.mediaURL = imageUri.toString();
      }
    }

    await _participantFirestoreService
        .postResponse(_studyUID, topicUID, questionUID, response)
        .then((response) {
      setState(() {
        _response = response;
        if (_question.respondedBy == null) {
          _question.respondedBy = [];
          _question.respondedBy.add(_response.participantUID);
        } else {
          _question.respondedBy.add(_response.participantUID);
        }

        var studyNavigatorTopics = _studyNavigatorTopics;

        for (var topic in studyNavigatorTopics) {
          for (var question in topic.questions) {
            if (question.questionUID == _questionUID) {
              if (question.respondedBy == null) {
                question.respondedBy = [];
                question.respondedBy.add(_response.participantUID);
              } else {
                question.respondedBy.add(_response.participantUID);
              }
            }
          }
        }
        _studyNavigatorTopics = studyNavigatorTopics;
        _questionAnswered = true;
      });
    });
  }

  Future<void> _updateResponse(
      String topicUID, String questionUID, Response response) async {
    await _participantFirestoreService.updateResponse(
        _studyUID, topicUID, questionUID, _participantUID, response);
  }

  Future<void> _postComment(
      String studyUID,
      String participantUID,
      String topicUID,
      String questionUID,
      String responseUID,
      String questionNumber,
      String questionTitle,
      Comment comment) async {
    _comment = await _participantFirestoreService.postComment(
        studyUID,
        participantUID,
        topicUID,
        questionUID,
        responseUID,
        questionNumber,
        questionTitle,
        comment);
  }

  void _getParticipantResponse(String studyUID, String topicUID,
      String questionUID, String participantUID) async {
    _response = await _firebaseFirestoreService.getParticipantResponse(
        studyUID, topicUID, questionUID, participantUID);

    if (_response == null) {
      _response = Response();
      _responseEditable = true;
    } else {
      _questionAnswered = true;
      _responseEditable = false;
    }
  }

  void _continueToNextQuestion(String nextTopicUID, String nextQuestionUID) {
    setState(() {
      _futureQuestion = _getQuestion(nextTopicUID, nextQuestionUID);
    });
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');
    _studyName = getStorage.read('studyName');

    _futureParticipant = _getParticipant(_studyUID, _participantUID);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Map<String, String> arguments = ModalRoute.of(context).settings.arguments;

    if (arguments == null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).popAndPushNamed(LOGIN_SCREEN);
      });
    }

    if (arguments != null) {
      _topicUID = arguments['topicUID'];
      _questionUID = arguments['questionUID'];
    }

    if (_topicUID != null ||
        _topicUID.isNotEmpty &&
            _questionUID != null &&
            _questionUID.isNotEmpty) {
      _futureQuestion = _getQuestion(_topicUID, _questionUID);
      _responsesStream =
          _getResponsesStream(_studyUID, _topicUID, _questionUID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height) {
      return buildPhoneScaffold(context, screenSize);
    } else {
      return _desktopScaffoldFutureBuilder();
    }
  }

  FutureBuilder _desktopScaffoldFutureBuilder() {
    return FutureBuilder(
      future: _futureParticipant,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Material(
              child: Center(
                child: Text(
                  'Something went wrong.',
                ),
              ),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Material(
              child: Center(
                child: Text('Loading...'),
              ),
            );
            break;
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  _studyName,
                  style: TextStyle(
                    color: TEXT_COLOR,
                  ),
                ),
                leadingWidth: 120.0,
                leading: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
                    },
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Text(
                      APP_NAME,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
                    },
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            'Go To Dashboard',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.7),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 14.0,
                          color: TEXT_COLOR.withOpacity(0.8),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: Row(
                children: [
                  _buildStudyNavigator(),
                  Expanded(
                    child: FutureBuilder(
                      future: _futureQuestion,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
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
                            return ListView(
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
                                _ResponseTextField(
                                  studyName: _studyName,
                                  hasMedia: _question.hasMedia,
                                  editable: _responseEditable,
                                  responseController:
                                      _participantResponseController,
                                  participant: _participant,
                                  response: _response,
                                  onTap: () async {
                                    setState(() {
                                      // _participantResponseController.clear();
                                    });
                                    _response.hasMedia = _question.hasMedia;
                                    _response.participantDisplayName =
                                        _participant.displayName;
                                    _response.participantUID = _participantUID;
                                    _response.responseTimestamp =
                                        Timestamp.now();
                                    _response.userName =
                                        _participant.userFirstName;
                                    _response.avatarURL =
                                        _participant.profilePhotoURL;
                                    _response.questionTitle =
                                        _question.questionTitle;
                                    _response.questionNumber =
                                        _question.questionNumber;

                                    if (_response.responseUID == null) {
                                      _response.claps = [];
                                      _response.comments = 0;
                                      _response.responseUID = null;

                                      _toggleResponseEditing();

                                      await _postResponse(
                                          _topicUID, _questionUID, _response);
                                    } else {
                                      _toggleResponseEditing();

                                      await _updateResponse(
                                          _topicUID, _questionUID, _response);
                                    }
                                  },
                                  onEditingPressed: () {
                                    _toggleResponseEditing();
                                  },
                                ),
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
                                          var responses = snapshot.data.docs;

                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                        color:
                                                            PROJECT_NAVY_BLUE,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var commentController =
                                                      TextEditingController();

                                                  var _commentsStream =
                                                      _getCommentsStream(
                                                          _studyUID,
                                                          _topicUID,
                                                          _questionUID,
                                                          responses[index]
                                                              ['responseUID']);

                                                  var response =
                                                      Response.fromMap(
                                                          responses[index]
                                                              .data());

                                                  return UserResponseWidget(
                                                    participantFirestoreService:
                                                        _participantFirestoreService,
                                                    participant: _participant,
                                                    participantUID:
                                                        _participantUID,
                                                    studyUID: _studyUID,
                                                    topicUID: _topicUID,
                                                    questionUID: _questionUID,
                                                    comment: _comment,
                                                    commentController:
                                                        commentController,
                                                    postCommentFunction:
                                                        () async {
                                                      setState(() {
                                                        commentController
                                                            .clear();
                                                      });

                                                      _comment.displayName =
                                                          _participant
                                                              .displayName;
                                                      _comment.participantName =
                                                          '${_participant.userFirstName} ${_participant.userLastName}';
                                                      _comment.avatarURL =
                                                          _participant
                                                              .profilePhotoURL;
                                                      _comment.commentTimestamp =
                                                          Timestamp.now();
                                                      _comment.participantUID =
                                                          _participantUID;

                                                      await _postComment(
                                                          _studyUID,
                                                          responses[index][
                                                              'participantUID'],
                                                          _topicUID,
                                                          _questionUID,
                                                          responses[index]
                                                              ['responseUID'],
                                                          _question
                                                              .questionNumber,
                                                          _question
                                                              .questionTitle,
                                                          _comment);
                                                    },
                                                    response: response,
                                                    commentStreamBuilder:
                                                        _commentsStreamBuilder(
                                                      _commentsStream,
                                                      _topicUID,
                                                      _questionUID,
                                                      responses[index]
                                                          ['responseUID'],
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          );
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
                                _question.respondedBy == null ? SizedBox() :
                                _question.respondedBy.contains(_participantUID)
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 40.0),
                                          child: FlatButton(
                                            onPressed: () {
                                              _continueToNextQuestion(
                                                  _nextTopicUID,
                                                  _nextQuestionUID);
                                            },
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
                                            color: PROJECT_GREEN,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            );
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
            break;
          default:
            return SizedBox();
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot> _commentsStreamBuilder(Stream commentsStream,
      String topicUID, String questionUID, String responseUID) {
    return StreamBuilder<QuerySnapshot>(
      stream: commentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return SizedBox();
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              var commentDocs = snapshot.data.docs;

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: commentDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  return CommentWidget(
                    studyUID: _studyUID,
                    topicUID: topicUID,
                    questionUID: questionUID,
                    responseUID: responseUID,
                    participantFirestoreService: _participantFirestoreService,
                    participantUID: _participantUID,
                    comment: Comment(
                        commentUID: commentDocs[index]['commentUID'],
                        avatarURL: commentDocs[index]['avatarURL'],
                        displayName: commentDocs[index]['displayName'],
                        participantName: commentDocs[index]['participantName'],
                        commentStatement: commentDocs[index]
                            ['commentStatement'],
                        participantUID: commentDocs[index]['participantUID'],
                        commentTimestamp: commentDocs[index]
                            ['commentTimestamp']),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10.0,
                  );
                },
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

  Align _buildStudyNavigator() {
    return Align(
      child: Container(
        color: Colors.white,
        constraints: BoxConstraints(
          maxWidth: 300.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Study Navigator',
                maxLines: 1,
                style: TextStyle(
                  color: TEXT_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
                },
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: TEXT_COLOR,
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Go back to dashboard',
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: _futureStudyNavigatorTopics,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return SizedBox();
                    break;
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: Text('Loading topics...'),
                    );
                    break;
                  case ConnectionState.done:
                    if (_studyNavigatorTopics.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _studyNavigatorTopics.length,
                        itemBuilder: (BuildContext context, int topicIndex) {
                          if (topicIndex == 0) {
                            _nextTopicUID =
                                _studyNavigatorTopics[topicIndex].topicUID;
                            return _buildDesktopStudyNavigatorExpansionTile(
                              _studyNavigatorTopics[topicIndex],
                              _participantUID,
                            );
                          } else {
                            if (_studyNavigatorTopics[topicIndex]
                                    .questions
                                    .last
                                    .respondedBy !=
                                null) {
                              if (_studyNavigatorTopics[topicIndex]
                                  .questions
                                  .last
                                  .respondedBy
                                  .contains(_participantUID)) {
                                // _nextTopicUID =
                                //     _studyNavigatorTopics[topicIndex].topicUID;
                                return _buildDesktopStudyNavigatorExpansionTile(
                                    _studyNavigatorTopics[topicIndex],
                                    _participantUID);
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return SizedBox();
                            }
                          }
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                    break;
                  default:
                    return SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopStudyNavigatorExpansionTile(
      Topic topic, String participantUID) {
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
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                if (index + 1 < topic.questions.length) {
                  _nextQuestionUID = topic.questions[index + 1].questionUID;
                } else {
                  _nextQuestionUID = topic.questions[index].questionUID;
                }
                return _buildDesktopStudyNavigatorActiveQuestion(
                  topic.questions[index],
                  topic.topicUID,
                );
              } else {
                if (topic.questions[index - 1].respondedBy != null) {
                  if (topic.questions[index - 1].respondedBy
                      .contains(participantUID)) {
                    if (index + 1 < topic.questions.length) {
                      _nextQuestionUID = topic.questions[index + 1].questionUID;
                    } else {
                      _nextQuestionUID = topic.questions[index].questionUID;
                    }
                    return _buildDesktopStudyNavigatorActiveQuestion(
                      topic.questions[index],
                      topic.topicUID,
                    );
                  } else {
                    return _buildDesktopStudyNavigatorLockedQuestion();
                  }
                } else {
                  return _buildDesktopStudyNavigatorLockedQuestion();
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

  Widget _buildDesktopStudyNavigatorActiveQuestion(
      Question question, String topicUID) {
    return InkWell(
      onTap: () {
        setState(() {
          _topicUID = topicUID;
          _questionUID = question.questionUID;

          _futureQuestion = _getQuestion(topicUID, question.questionUID);
          _responsesStream =
              _getResponsesStream(_studyUID, topicUID, question.questionUID);
        });
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
                  : question.respondedBy.contains(_participantUID)
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

  Widget _buildDesktopStudyNavigatorLockedQuestion() {
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
            Text(
              'Question Locked',
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
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

  Scaffold buildPhoneScaffold(BuildContext context, Size screenSize) {
    return Scaffold(
      key: _participantResponseScreenScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          APP_NAME,
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: PROJECT_GREEN,
            ),
            onPressed: () => _participantResponseScreenScaffoldKey.currentState
                .openEndDrawer(),
          ),
        ],
      ),
      endDrawer: _buildPhoneEndDrawer(),
      body: FutureBuilder(
        future: _futureQuestion,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text(
                  'Something went wrong.',
                ),
              );
              break;
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: Text('Loading...'),
              );
              break;
            case ConnectionState.done:
              return ListView(
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
                    height: 30.0,
                  ),
                  _ResponseTextField(
                    participant: _participant,
                    response: _response,
                    onTap: () async {
                      // _response.timeElapsed = '0';
                      _response.participantDisplayName =
                          _participant.displayName;
                      _response.claps = [];
                      _response.participantUID = _participantUID;
                      _response.responseTimestamp = Timestamp.now();
                      _response.userName = _participant.userFirstName;
                      _response.avatarURL = _participant.profilePhotoURL;
                      _response.comments = 0;
                      _response.questionNumber = _question.questionNumber;
                      _response.questionTitle = _question.questionTitle;
                      // await _postResponse(_studyUID, );
                    },
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                    child: Text(
                      'All responses',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.5),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream:
                    _getResponsesStream(_studyUID, _topicUID, _questionUID),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return SizedBox();
                          break;
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            var responses = snapshot.data.documents;

                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: responses.length,
                              itemBuilder: (BuildContext context, int index) {
                                return UserResponseWidget(
                                  participantFirestoreService:
                                  _participantFirestoreService,
                                  participantUID: _participantUID,
                                  studyUID: _studyUID,
                                  topicUID: _topicUID,
                                  questionUID: _questionUID,
                                  comment: _comment,
                                  postCommentFunction: () async {
                                    _comment.displayName =
                                    responses[index]['alias'];
                                    _comment.participantName =
                                    responses[index]['userName'];
                                    _comment.avatarURL =
                                    responses[index]['avatarURL'];
                                    _comment.commentTimestamp = Timestamp.now();
                                    _comment.participantUID = _participantUID;
                                  },
                                  response: Response(
                                    responseUID: responses[index]
                                    ['participantUID'] ==
                                        _participant.participantUID
                                        ? _response.responseUID
                                        : responses[index]['responseUID'],
                                    participantUID: responses[index]
                                    ['participantUID'],
                                    avatarURL: responses[index]['avatarURL'],
                                    participantDisplayName: responses[index]
                                    ['alias'],
                                    userName: responses[index]['userName'],
                                    timeElapsed: responses[index]
                                    ['timeElapsed'],
                                    responseStatement: responses[index]
                                    ['responseStatement'],
                                    claps: responses[index]['claps'],
                                    comments: responses[index]['comments'],
                                    responseTimestamp: responses[index]
                                    ['responseTimestamp'],
                                  ),
                                );
                              },
                            );
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
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(TOPIC_COMPLETE_SCREEN),
                            color: PROJECT_GREEN,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              );
              break;
            default:
              return SizedBox();
          }
        },
      ),
    );
  }

  Drawer _buildPhoneEndDrawer() {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF333333),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Study Navigator',
                  style: TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: Color(0xFFE5E5E5),
            margin: EdgeInsets.only(
              top: 5.0,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _futureStudyNavigatorTopics,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: Text('Loading Topics...'),
                    );
                    break;
                  case ConnectionState.done:
                    if (_studyNavigatorTopics != null) {
                      return ListView.builder(
                        itemCount: _studyNavigatorTopics.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EndDrawerExpansionTile(
                            title: _studyNavigatorTopics[index].topicName,
                            questions: _studyNavigatorTopics[index].questions,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Some error occurred'),
                      );
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
}

class _ResponseTextField extends StatefulWidget {
  final String studyName;

  final bool hasMedia;
  final Participant participant;
  final Response response;
  final Function onTap;
  final Function onEditingPressed;
  final TextEditingController responseController;
  final bool editable;

  const _ResponseTextField({
    Key key,
    this.participant,
    this.onTap,
    this.response,
    this.responseController,
    this.editable,
    this.onEditingPressed,
    this.hasMedia,
    this.studyName,
  }) : super(key: key);

  @override
  __ResponseTextFieldState createState() => __ResponseTextFieldState();
}

class __ResponseTextFieldState extends State<_ResponseTextField> {
  final _participantStorageService = ParticipantStorageService();

  VideoPlayerController _videoPlayerController;

  String _videoURL = '';

  String _date;
  String _time;

  DateFormat formatDate;
  DateFormat formatTime;

  NetworkImage _pickedImage;
  var _pickedVideo;

  bool _mediaPicked = false;

  Future<void> _pickImage() async {
    var pickedImageFile =
        await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (pickedImageFile != null) {
      widget.response.mediaType = 'image';
      widget.response.media = pickedImageFile;

      var blobImage = BlobImage(pickedImageFile, name: pickedImageFile.name);

      print(blobImage.url);

      _pickedImage = NetworkImage(blobImage.url);

      setState(() {
        _mediaPicked = true;
      });
    }
  }

  // Future<void> _pickVideo() async {
  //   File pickedVideoFile =
  //       await ImagePickerWeb.getVideo(outputType: VideoType.file);
  //
  //   if (pickedVideoFile != null) {
  //     widget.response.mediaType = 'video';
  //     widget.response.media = pickedVideoFile;
  //
  //     var videoURI = await _participantStorageService.uploadVideoToFirebase(
  //         widget.studyName, widget.participant.participantUID, pickedVideoFile);
  //
  //     widget.response.mediaURL = videoURI.toString();
  //
  //     _videoPlayerController =
  //         VideoPlayerController.network(widget.response.mediaURL);
  //
  //     await _videoPlayerController.initialize();
  //
  //     await _videoPlayerController.play();
  //     await _videoPlayerController.setLooping(true);
  //
  //     setState(() {
  //       _mediaPicked = true;
  //     });
  //   }
  // }

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    widget.responseController.text = widget.response.responseStatement;

    if (widget.response.mediaType == 'video') {
      _videoURL = widget.response.mediaURL;
      _videoPlayerController = VideoPlayerController.network(_videoURL)
        ..initialize().then((value) {
          setState(() {});
        });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formatDate = DateFormat.yMd();
    formatTime = DateFormat.jm();

    if (widget.response.responseTimestamp != null) {
      _date = formatDate.format(widget.response.responseTimestamp.toDate());
      _time = formatTime.format(widget.response.responseTimestamp.toDate());
    } else {
      _date = formatDate.format(Timestamp.now().toDate());
      _time = formatTime.format(Timestamp.now().toDate());
    }

    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.participant.profilePhotoURL,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: PROJECT_LIGHT_GREEN,
                                ),
                                child: Center(
                                  child: Image(
                                    width: 20.0,
                                    image: imageProvider,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.participant.displayName,
                                style: TextStyle(
                                  color: TEXT_COLOR.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                ),
                              ),
                              widget.editable
                                  ? SizedBox()
                                  : SizedBox(
                                      height: 2.0,
                                    ),
                              widget.editable
                                  ? SizedBox()
                                  : Text(
                                      '$_date at $_time',
                                      style: TextStyle(
                                        color: TEXT_COLOR.withOpacity(0.6),
                                        fontSize: 10.0,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      widget.editable
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit_rounded,
                                  color: TEXT_COLOR.withOpacity(0.6),
                                  size: 16.0,
                                ),
                                onPressed: widget.onEditingPressed,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: widget.editable,
                            controller: widget.responseController,
                            maxLines: 20,
                            minLines: 1,
                            onChanged: (responseStatement) {
                              setState(() {
                                if (responseStatement.trim().isNotEmpty) {
                                  widget.response.responseStatement =
                                      responseStatement;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write your response',
                              hintStyle: TextStyle(
                                color: TEXT_COLOR.withOpacity(0.4),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        widget.hasMedia ? SizedBox(width: 20.0) : SizedBox(),
                        widget.hasMedia
                            ? _mediaPicked
                                ? InkWell(
                                    onTap: widget.editable
                                        ? () async {
                                            await showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel: 'Image Picker',
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Material(
                                                      child: ButtonBar(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              await _pickImage()
                                                                  .then(
                                                                      (value) {
                                                                Navigator.of(
                                                                        buildContext)
                                                                    .pop();
                                                              });
                                                            },
                                                            child: Text(
                                                                'Pick Image'),
                                                          ),
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              // await _pickVideo()
                                                              //     .then(
                                                              //         (value) {
                                                              //   Navigator.of(
                                                              //           buildContext)
                                                              //       .pop();
                                                              // });
                                                            },
                                                            child: Text(
                                                                'Pick Video'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        : null,
                                    child: Align(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.grey[700],
                                            width: 1.0,
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                            maxWidth: 300.0, maxHeight: 200.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: widget.response.mediaType ==
                                                  'image'
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      widget.response.mediaURL,
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image(
                                                        image: imageProvider,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : VideoPlayer(
                                                  _videoPlayerController),
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: widget.editable
                                        ? () async {
                                            await showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel: 'Media Picker',
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Material(
                                                      child: ButtonBar(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              await _pickImage()
                                                                  .then(
                                                                      (value) {
                                                                Navigator.of(
                                                                        buildContext)
                                                                    .pop();
                                                              });
                                                            },
                                                            child: Text(
                                                                'Pick Image'),
                                                          ),
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              // await _pickVideo()
                                                              //     .then(
                                                              //         (value) {
                                                              //   Navigator.of(
                                                              //           buildContext)
                                                              //       .pop();
                                                              // });
                                                            },
                                                            child: Text(
                                                                'Pick Video'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        : null,
                                    child: Align(
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 300.0, maxHeight: 200.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.grey[700],
                                            width: 1.0,
                                          ),
                                        ),
                                        child: widget.response.mediaURL == null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.add_circle_outline,
                                                      color: Colors.grey[800],
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Text(
                                                      'Image/Video',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : widget.response.mediaType ==
                                                    'image'
                                                ? CachedNetworkImage(
                                                    imageUrl: widget
                                                        .response.mediaURL,
                                                    imageBuilder: (context,
                                                        imageProvider) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image(
                                                          image: imageProvider,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : VideoPlayer(
                                                    _videoPlayerController,
                                                  ),
                                      ),
                                    ),
                                  )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            widget.editable
                ? Row(
                    children: [
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
                          ),
                          color: widget.responseController.value.text
                                  .trim()
                                  .isNotEmpty
                              ? PROJECT_GREEN
                              : Colors.grey[500],
                          child: InkWell(
                            highlightColor: Colors.black.withOpacity(0.2),
                            splashColor: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: widget.responseController.value.text
                                    .trim()
                                    .isNotEmpty
                                ? widget.onTap
                                : null,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
