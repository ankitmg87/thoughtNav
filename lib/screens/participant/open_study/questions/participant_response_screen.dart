import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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

  String _studyUID;
  String _participantUID;
  String _topicUID;
  String _questionUID;

  double value = 40.5;
  double minMenuWidth = 40.5;
  double maxMenuWidth = 300.0;
  double studyNavigatorWidth;

  bool isExpanded = false;
  bool showDrawer = false;

  Participant _participant;
  Question _question;
  Response _response = Response();
  Comment _comment = Comment();

  List<Topic> _topics;

  Future<void> _futureParticipant;
  Future<void> _futureTopics;
  Future<void> _futureQuestion;

  Stream<QuerySnapshot> _responsesStream;

  Future<void> _getTopics(String studyUID) async {
    _topics = await _firebaseFirestoreService.getTopics(studyUID);
  }

  Future<void> _getParticipant(String studyUID, String participantUID) async {
    _participant = await _firebaseFirestoreService.getParticipant(
        studyUID, participantUID);
  }

  Future<void> _getQuestion(String studyUID) async {
    Map<String, String> arguments =
        await ModalRoute.of(context).settings.arguments;

    _topicUID = arguments['topicUID'];
    _questionUID = arguments['questionUID'];

    _getParticipantResponse();

    // _responsesStream = _getResponsesStream(studyUID);

    _question = await _firebaseFirestoreService.getQuestion(
        studyUID, _topicUID, _questionUID);
  }

  Stream<QuerySnapshot> _getResponsesStream(
      String studyUID, String topicUID, String questionUID) {
    return _firebaseFirestoreService.getResponsesAsStream(
        studyUID, topicUID, questionUID);
  }

  Future<void> _postResponse() async {
    _response = await _firebaseFirestoreService.postResponse(
        _studyUID, _topicUID, _questionUID, _response);
  }

  Future<void> _postComment(String studyUID, String topicUID,
      String questionUID, String responseUID, Comment comment) async {
    _comment = await _firebaseFirestoreService.postComment(
        studyUID, topicUID, questionUID, responseUID, comment);
  }

  void _getParticipantResponse() async {
    _response = await _firebaseFirestoreService.getParticipantResponse(
        _studyUID, _topicUID, _questionUID, _participantUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyUID = getStorage.read('studyUID');
    _participantUID = getStorage.read('participantUID');

    _futureTopics = _getTopics(_studyUID);
    _futureParticipant = _getParticipant(_studyUID, _participantUID);
    // _responsesStream = _getResponsesStream(_studyUID);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _futureQuestion = _getQuestion(_studyUID);
    super.didChangeDependencies();
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
                      _response.timeElapsed = '0';
                      _response.alias = _participant.alias;
                      _response.claps = [];
                      _response.participantUID = _participantUID;
                      _response.responseTimestamp = Timestamp.now();
                      _response.userName = _participant.userName;
                      _response.avatarURL = _participant.profilePhotoURL;
                      _response.comments = 0;
                      _response.questionNumber = _question.questionNumber;
                      _response.questionTitle = _question.questionTitle;
                      await _postResponse();
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
                    stream: _responsesStream,
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
                                  firebaseFirestoreService:
                                      _firebaseFirestoreService,
                                  participantUID: _participantUID,
                                  studyUID: _studyUID,
                                  topicUID: _topicUID,
                                  questionUID: _questionUID,
                                  comment: _comment,
                                  postCommentFunction: () async {
                                    _comment.alias = responses[index]['alias'];
                                    _comment.userName =
                                        responses[index]['userName'];
                                    _comment.avatarURL =
                                        responses[index]['avatarURL'];
                                    _comment.date = 'current date';
                                    _comment.timeElapsed = 'time elapsed';
                                    _comment.commentTimestamp = Timestamp.now();
                                    _comment.userUID = _participantUID;

                                    await _postComment(
                                        _studyUID,
                                        _topicUID,
                                        _questionUID,
                                        responses[index]['responseUID'],
                                        _comment);
                                  },
                                  response: Response(
                                    responseUID: responses[index]
                                        ['responseUID'],
                                    participantUID: responses[index]
                                        ['participantUID'],
                                    avatarURL: responses[index]['avatarURL'],
                                    alias: responses[index]['alias'],
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
                title: Text(
                  APP_NAME,
                  style: TextStyle(
                    color: TEXT_COLOR,
                  ),
                ),
                actions: [
                  Center(
                    child: Text(
                      'Hello ${_participant.userName}',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.7),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: CachedNetworkImage(
                      imageUrl: _participant.profilePhotoURL,
                      imageBuilder: (buildContext, imageProvider) {
                        return Container(
                          padding: EdgeInsets.all(6.0),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PROJECT_LIGHT_GREEN,
                          ),
                          child: Image(
                            width: 20.0,
                            image: imageProvider,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              body: Row(
                children: [
                  // Container(
                  //   constraints: BoxConstraints(
                  //     maxWidth: 300.0,
                  //   ),
                  //   color: Colors.white,
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.max,
                  //     children: [
                  //       Container(
                  //         alignment: Alignment.center,
                  //         padding: EdgeInsets.symmetric(
                  //             horizontal: 30.0, vertical: 20.0),
                  //         child: Text(
                  //           'Study Navigator',
                  //           style: TextStyle(
                  //             color: TEXT_COLOR.withOpacity(0.7),
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12.0,
                  //           ),
                  //         ),
                  //       ),
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             child: Container(
                  //               height: 1.0,
                  //               color: TEXT_COLOR.withOpacity(0.2),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Expanded(
                  //         child: FutureBuilder(
                  //           future: _futureTopics,
                  //           builder: (BuildContext context,
                  //               AsyncSnapshot<dynamic> snapshot) {
                  //             switch (snapshot.connectionState) {
                  //               case ConnectionState.none:
                  //               case ConnectionState.waiting:
                  //               case ConnectionState.active:
                  //                 return Center(
                  //                   child: Text('Loading Topics...'),
                  //                 );
                  //                 break;
                  //               case ConnectionState.done:
                  //                 if (_topics != null) {
                  //                   return ListView.builder(
                  //                     itemCount: _topics.length,
                  //                     itemBuilder:
                  //                         (BuildContext context, int index) {
                  //                       return EndDrawerExpansionTile(
                  //                         title: _topics[index].topicName,
                  //                         questions: _topics[index].questions,
                  //                       );
                  //                     },
                  //                   );
                  //                 } else {
                  //                   return Center(
                  //                     child: Text('Some error occurred'),
                  //                   );
                  //                 }
                  //                 break;
                  //               default:
                  //                 return SizedBox();
                  //             }
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Align(
                    child: AnimatedContainer(
                      curve: Curves.ease,
                      height: double.maxFinite,
                      width: value,
                      color: Colors.white,
                      duration: Duration(milliseconds: 200),
                      onEnd: () {
                        setState(() {
                          if (isExpanded) {
                            showDrawer = true;
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: showDrawer
                                      ? Text(
                                          'Study Navigator',
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: TEXT_COLOR,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  showDrawer ? Icons.close : Icons.menu,
                                  color: PROJECT_GREEN,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (!isExpanded) {
                                      value = maxMenuWidth;
                                      isExpanded = !isExpanded;
                                    } else {
                                      value = minMenuWidth;
                                      isExpanded = !isExpanded;
                                      showDrawer = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          showDrawer
                              ? Expanded(
                                  child: FutureBuilder(
                                    future: _futureTopics,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
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
                                          if (_topics.isNotEmpty) {
                                            return ListView.builder(
                                              itemCount: _topics.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int topicIndex) {
                                                return ExpansionTile(
                                                  title: Text(
                                                    _topics[topicIndex]
                                                        .topicName,
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      itemCount:
                                                          _topics[topicIndex]
                                                              .questions
                                                              .length,
                                                      itemBuilder: (BuildContext
                                                              context,
                                                          int questionIndex) {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _topicUID = _topics[
                                                                      topicIndex]
                                                                  .topicUID;
                                                              _questionUID = _topics[
                                                                      topicIndex]
                                                                  .questions[
                                                                      questionIndex]
                                                                  .questionUID;
                                                            });

                                                            print(_topicUID);
                                                            print(_questionUID);
                                                          },
                                                          splashColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '${_topics[topicIndex].questions[questionIndex].questionNumber}  ${_topics[topicIndex].questions[questionIndex].questionTitle}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      13.0,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return SizedBox(
                                                            height: 20.0);
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                  ],
                                                );
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
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
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
                                  participant: _participant,
                                  response: _response,
                                  onTap: () async {
                                    _response.timeElapsed = '0';
                                    _response.alias = _participant.alias;
                                    _response.claps = [];
                                    _response.participantUID = _participantUID;
                                    _response.responseTimestamp =
                                        Timestamp.now();
                                    _response.userName = _participant.userName;
                                    _response.avatarURL =
                                        _participant.profilePhotoURL;
                                    _response.comments = 0;
                                    _response.questionTitle = _question.questionTitle;
                                    _response.questionNumber = _question.questionNumber;
                                    await _postResponse();
                                  },
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                StreamBuilder(
                                  stream: _getResponsesStream(
                                      _studyUID, _topicUID, _questionUID),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return SizedBox();
                                        break;
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        if (snapshot.hasData) {
                                          var responses =
                                              snapshot.data.documents;

                                          return ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: responses.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return UserResponseWidget(
                                                firebaseFirestoreService:
                                                    _firebaseFirestoreService,
                                                participantUID: _participantUID,
                                                studyUID: _studyUID,
                                                topicUID: _topicUID,
                                                questionUID: _questionUID,
                                                comment: _comment,
                                                postCommentFunction: () async {
                                                  _comment.alias =
                                                      responses[index]['alias'];
                                                  _comment.userName =
                                                      responses[index]
                                                          ['userName'];
                                                  _comment.avatarURL =
                                                      responses[index]
                                                          ['avatarURL'];
                                                  _comment.date =
                                                      'current date';
                                                  _comment.timeElapsed =
                                                      'time elapsed';
                                                  _comment.commentTimestamp =
                                                      Timestamp.now();
                                                  _comment.userUID =
                                                      _participantUID;

                                                  await _postComment(
                                                      _studyUID,
                                                      _topicUID,
                                                      _questionUID,
                                                      responses[index]
                                                          ['responseUID'],
                                                      _comment);
                                                },
                                                response: Response(
                                                  responseUID: responses[index]
                                                      ['responseUID'],
                                                  participantUID:
                                                      responses[index]
                                                          ['participantUID'],
                                                  avatarURL: responses[index]
                                                      ['avatarURL'],
                                                  alias: responses[index]
                                                      ['alias'],
                                                  userName: responses[index]
                                                      ['userName'],
                                                  timeElapsed: responses[index]
                                                      ['timeElapsed'],
                                                  responseStatement:
                                                      responses[index]
                                                          ['responseStatement'],
                                                  claps: responses[index]
                                                      ['claps'],
                                                  comments: responses[index]
                                                      ['comments'],
                                                  responseTimestamp:
                                                      responses[index]
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
              future: _futureTopics,
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
                    if (_topics != null) {
                      return ListView.builder(
                        itemCount: _topics.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EndDrawerExpansionTile(
                            title: _topics[index].topicName,
                            questions: _topics[index].questions,
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
  final Participant participant;
  final Response response;
  final Function onTap;

  const _ResponseTextField({
    Key key,
    this.participant,
    this.onTap,
    this.response,
  }) : super(key: key);

  @override
  __ResponseTextFieldState createState() => __ResponseTextFieldState();
}

class __ResponseTextFieldState extends State<_ResponseTextField> {
  @override
  Widget build(BuildContext context) {
    if (widget.participant.participantUID == widget.response.participantUID) {
      return Padding(
        padding:
            EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 20.0),
        child: Card(
          elevation: 2.0,
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
                              imageUrl: widget.response.avatarURL,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image(
                                    width: 20.0,
                                    image: imageProvider,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.response.alias,
                                  style: TextStyle(
                                    color: TEXT_COLOR.withOpacity(0.6),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  '${widget.response.responseTimestamp}',
                                  style: TextStyle(
                                    color: TEXT_COLOR.withOpacity(0.6),
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          widget.response.timeElapsed,
                          style: TextStyle(
                            color: PROJECT_GREEN,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        widget.response.responseStatement,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding:
            EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 20.0),
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
                        Text(
                          widget.participant.alias,
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
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
                      child: TextField(
                        maxLines: 3,
                        minLines: 3,
                        onChanged: (responseStatement) {
                          widget.response.responseStatement = responseStatement;
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
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.0),
                        bottomRight: Radius.circular(4.0),
                      ),
                      color: PROJECT_GREEN,
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
                        onTap: widget.onTap,
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
}
