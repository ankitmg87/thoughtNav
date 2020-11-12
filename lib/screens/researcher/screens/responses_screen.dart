import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/screens/sub_screens/question_and_responses_sub_screen.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class ResponsesScreen extends StatefulWidget {
  @override
  _ResponsesScreenState createState() => _ResponsesScreenState();
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  double minMenuWidth = 40.5;
  double maxMenuWidth = 300.0;
  double studyNavigatorWidth;

  bool isExpanded = false;

  String _studyUID;
  String _studyName;
  String _internalStudyLabel;
  String _topicUID;
  String _questionUID;
  String _topicName;

  Future<List<Topic>> _getTopicsAndQuestions;

  void _getTopics() {
    _getTopicsAndQuestions = _firebaseFirestoreService.getTopics(_studyUID);
  }

  @override
  void initState() {
    studyNavigatorWidth = minMenuWidth;
    var getStorage = GetStorage();
    _studyUID = getStorage.read('studyUID');
    _studyName = getStorage.read('studyName');
    _internalStudyLabel = getStorage.read('internalStudyLabel');

    Future.delayed(Duration(seconds: 0), () {
      Map arguments = ModalRoute.of(context).settings.arguments;
      _topicUID = arguments['topicUID'];
      _questionUID = arguments['questionUID'];
    });

    super.initState();
    _getTopics();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenSize.width,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            color: Colors.white,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'ACCESS TYPE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
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
                                            return ExpansionTile(
                                              title: Text(
                                                snapshot.data[topicIndex].topicName,
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
                                                  itemCount: snapshot
                                                      .data[topicIndex]
                                                      .questions
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int questionIndex) {
                                                    return InkWell(
                                                      onTap: () {
                                                        _topicName = snapshot.data[topicIndex].topicName;
                                                        _topicUID = snapshot.data[topicIndex].topicUID;
                                                        _questionUID = snapshot.data[questionIndex].questions[questionIndex].questionUID;
                                                        setState(() {});
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
                QuestionAndResponsesSubScreen(
                  screenSize: screenSize,
                  firebaseFirestoreService: _firebaseFirestoreService,
                  studyUID: _studyUID,
                  topicUID: _topicUID,
                  questionUID: _questionUID,
                  studyName: _studyName,
                  internalStudyLabel: _internalStudyLabel,
                  topicName: _topicName,
                ),
              ],
            ),
          ),
        ],
      ),
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
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Stack(
              children: [
                Container(
                  child: Image(
                    image: AssetImage('images/avatars/batman.png'),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StudyNavigatorExpansionTile extends StatefulWidget {
  final Topic topic;
  final Function onQuestionTap;

  const StudyNavigatorExpansionTile({Key key, this.topic, this.onQuestionTap})
      : super(key: key);

  @override
  _StudyNavigatorExpansionTileState createState() =>
      _StudyNavigatorExpansionTileState();
}

class _StudyNavigatorExpansionTileState
    extends State<StudyNavigatorExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.topic.topicName,
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
          itemCount: widget.topic.questions.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {},
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  Text(
                    '${widget.topic.questions[index].questionNumber}  ${widget.topic.questions[index].questionTitle}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 20.0);
          },
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
