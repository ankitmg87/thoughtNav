import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/insight.dart';
import 'package:thoughtnav/screens/researcher/models/moderator.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/screens/sub_screens/question_and_responses_sub_screen.dart';
import 'package:thoughtnav/screens/researcher/widgets/insight_widget.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class ResponsesScreen extends StatefulWidget {
  @override
  _ResponsesScreenState createState() => _ResponsesScreenState();
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _firebaseFirestoreService = FirebaseFirestoreService();

  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  double minMenuWidth = 40.5;
  double maxMenuWidth = 300.0;
  double studyNavigatorWidth;

  bool isExpanded = false;

  Question _currentQuestion;

  String _studyUID = '';
  String _topicUID = '';
  String _questionUID = '';
  String _userType = '';

  Moderator _moderator = Moderator();

  Future<void> _getStudyAndTopicUIDs;

  Stream<QuerySnapshot> _insightsStream;

  Stream<QuerySnapshot> _getInsightsStream(
      String studyUID, String topicUID, String questionUID) {
    return _researcherAndModeratorFirestoreService.streamInsights(
        studyUID, topicUID, questionUID);
  }

  Future<void> _future(
      String studyUID, String topicUID, String questionUID) async {
    _currentQuestion = await _researcherAndModeratorFirestoreService
        .getQuestion(studyUID, topicUID, questionUID);

    if (_userType == 'moderator') {
      var getStorage = GetStorage();

      var moderatorUID = getStorage.read('moderatorUID');

      _moderator = await _researcherAndModeratorFirestoreService
          .getModerator(moderatorUID);
    }
  }

  Future<List<Topic>> _getTopicsAndQuestions;

  FutureBuilder _questionAndResponsesFutureBuilderWidget;

  Future<void> _getStudyUIDAndTopicUID() async {
    await Future.delayed(Duration(seconds: 0), () {
      Map arguments = ModalRoute.of(context).settings.arguments;

      if (arguments != null) {
        _topicUID = arguments['topicUID'];
        _questionUID = arguments['questionUID'];
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).popAndPushNamed(LOGIN_SCREEN);
        });
      }
    });

    _currentQuestion = await _researcherAndModeratorFirestoreService
        .getQuestion(_studyUID, _topicUID, _questionUID);
    _insightsStream = _getInsightsStream(_studyUID, _topicUID, _questionUID);
  }

  void _getTopics() {
    _getTopicsAndQuestions =
        _researcherAndModeratorFirestoreService.getTopics(_studyUID);
  }

  @override
  void initState() {
    studyNavigatorWidth = minMenuWidth;
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _userType = getStorage.read('userType');

    _getTopics();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getStudyAndTopicUIDs = _getStudyUIDAndTopicUID();
    _questionAndResponsesFutureBuilderWidget =
        _questionsAndResponsesFutureBuilder(_getStudyAndTopicUIDs);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  curve: Curves.easeOut,
                  width: studyNavigatorWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[300],
                        width: 0.5,
                      ),
                      right: BorderSide(
                        color: Colors.grey[300],
                        width: 0.5,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  duration: Duration(milliseconds: 200),
                  onEnd: () {
                    setState(() {
                      if (studyNavigatorWidth == maxMenuWidth) {
                        isExpanded = !isExpanded;
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isExpanded
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    'Study Navigator',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: PROJECT_GREEN,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isExpanded) {
                                  isExpanded = !isExpanded;
                                  studyNavigatorWidth = minMenuWidth;
                                } else {
                                  studyNavigatorWidth = maxMenuWidth;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: isExpanded
                            ? FutureBuilder(
                                future: _getTopicsAndQuestions,
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
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int topicIndex) {
                                            return Theme(
                                              data: ThemeData(
                                                accentColor: PROJECT_GREEN,
                                                unselectedWidgetColor:
                                                    Colors.black,
                                              ),
                                              child: ExpansionTile(
                                                title: Text(
                                                  snapshot.data[topicIndex]
                                                      .topicName,
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
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.only(
                                                      left: 20.0,
                                                      right: 10.0,
                                                    ),
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data[topicIndex]
                                                        .questions
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int questionIndex) {
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _topicUID = snapshot
                                                                .data[
                                                                    topicIndex]
                                                                .topicUID;
                                                            _questionUID = snapshot
                                                                .data[
                                                                    topicIndex]
                                                                .questions[
                                                                    questionIndex]
                                                                .questionUID;

                                                            _getStudyAndTopicUIDs =
                                                                _future(
                                                                    _studyUID,
                                                                    _topicUID,
                                                                    _questionUID);

                                                            _questionAndResponsesFutureBuilderWidget =
                                                                _questionsAndResponsesFutureBuilder(
                                                                    _getStudyAndTopicUIDs);

                                                            _insightsStream =
                                                                _getInsightsStream(
                                                                    _studyUID,
                                                                    _topicUID,
                                                                    _questionUID);
                                                          });
                                                        },
                                                        splashColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[topicIndex].questions[questionIndex].questionNumber}  ${snapshot.data[topicIndex].questions[questionIndex].questionTitle}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[800],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13.0,
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
                                              ),
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
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
                _questionAndResponsesFutureBuilderWidget,
              ],
            ),
          ),
        ],
      ),
      endDrawer: _buildInsightsDrawer(_insightsStream),
    );
  }

  Widget _buildInsightsDrawer(Stream<QuerySnapshot> insightsStream) {
    var insight = Insight();

    var insightController = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: 500.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Insights',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Add an Insight',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: TextFormField(
              controller: insightController,
              minLines: 1,
              maxLines: 20,
              decoration: InputDecoration(
                hintText: 'Write an insight',
              ),
              onChanged: (insightStatement) {
                insight.insightStatement = insightStatement;
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: RaisedButton(
              onPressed: () async {
                if (insight.insightStatement != null) {
                  if (insight.insightStatement.trim().isNotEmpty) {

                    insight.avatarURL = _moderator.moderatorAvatar;
                    insight.name = _moderator.firstName != null
                        ? '${_moderator.firstName} ${_moderator.lastName}'
                        : null;
                    insight.insightTimestamp = Timestamp.now();
                    insight.questionUID = _currentQuestion.questionUID;
                    insight.topicUID = _topicUID;
                    insight.questionTitle = _currentQuestion.questionTitle;
                    insight.questionNumber = _currentQuestion.questionNumber;

                    insightController.clear();

                    await _researcherAndModeratorFirestoreService.postInsight(
                        _studyUID, _topicUID, _questionUID, insight);
                  }
                }
              },
              color: PROJECT_GREEN,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'All Insights',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: insightsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return SizedBox();
                  break;
                case ConnectionState.waiting:
                  return SizedBox();
                  break;
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.isNotEmpty) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InsightWidget(
                            insight: Insight.fromMap(
                                snapshot.data.docs[index].data()),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10.0,
                          );
                        },
                      );
                    } else {
                      return Center();
                    }
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
          ),
        ],
      ),
    );
  }

  FutureBuilder _questionsAndResponsesFutureBuilder(Future<void> future) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return QuestionAndResponsesSubScreen(
            studyUID: _studyUID,
            topicUID: _topicUID,
            questionUID: _questionUID,
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: 140.0,
      leading: Center(
        child: Text(
          ' ThoughtNav',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
      title: Text(
        'Responses',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _scaffoldKey.currentState.openEndDrawer();
                });
              },
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.article_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Add Insights',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
          width: 1.0,
          height: kToolbarHeight,
          color: Colors.grey[300],
        ),
        SizedBox(
          width: 10.0,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Go To Dashboard',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class StudyNavigatorExpansionTile extends StatefulWidget {
//   final Topic topic;
//   final Function onQuestionTap;
//
//   const StudyNavigatorExpansionTile({Key key, this.topic, this.onQuestionTap})
//       : super(key: key);
//
//   @override
//   _StudyNavigatorExpansionTileState createState() =>
//       _StudyNavigatorExpansionTileState();
// }
//
// class _StudyNavigatorExpansionTileState
//     extends State<StudyNavigatorExpansionTile> {
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text(
//         widget.topic.topicName,
//         style: TextStyle(
//           color: Colors.grey[700],
//           fontWeight: FontWeight.bold,
//           fontSize: 14.0,
//         ),
//       ),
//       children: [
//         SizedBox(
//           height: 10.0,
//         ),
//         ListView.separated(
//           padding: EdgeInsets.only(
//             left: 20.0,
//             right: 10.0,
//           ),
//           shrinkWrap: true,
//           itemCount: widget.topic.questions.length,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {},
//               splashColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               focusColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               child: Row(
//                 children: [
//                   Text(
//                     '${widget.topic.questions[index].questionNumber}  ${widget.topic.questions[index].questionTitle}',
//                     style: TextStyle(
//                       color: Colors.grey[800],
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13.0,
//                     ),
//                   )
//                 ],
//               ),
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return SizedBox(height: 20.0);
//           },
//         ),
//         SizedBox(
//           height: 20.0,
//         ),
//       ],
//     );
//   }
// }
