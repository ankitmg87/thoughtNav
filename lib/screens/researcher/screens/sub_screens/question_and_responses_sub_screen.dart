import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/response.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/response_widget.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class QuestionAndResponsesSubScreen extends StatefulWidget {
  const QuestionAndResponsesSubScreen({
    Key key,
    this.studyUID,
    this.topicUID,
    this.questionUID,
  }) : super(key: key);

  final String studyUID;
  final String topicUID;
  final String questionUID;

  @override
  _QuestionAndResponsesSubScreenState createState() =>
      _QuestionAndResponsesSubScreenState();
}

class _QuestionAndResponsesSubScreenState
    extends State<QuestionAndResponsesSubScreen> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  final _scrollController = ScrollController();

  Future<Topic> _futureTopic;
  Future<Question> _futureQuestion;

  Stream<QuerySnapshot> _streamResponses;

  Topic _topic;
  Question _question;

  Future<Topic> _getFutureTopic(String studyUID, String topicUID) async {
    _topic = await _researcherAndModeratorFirestoreService.getTopic(
        studyUID, topicUID);
    return _topic;
  }

  Future<Question> _getFutureQuestion(
      String studyUID, String topicUID, String questionUID) async {
    _question = await _researcherAndModeratorFirestoreService.getQuestion(
        studyUID, topicUID, questionUID);
    return _question;
  }

  Stream<QuerySnapshot> _getResponsesStream(
      String studyUID, String topicUID, String questionUID) {
    return _researcherAndModeratorFirestoreService.streamResponses(
        studyUID, topicUID, questionUID);
  }

  String topicUID;

  @override
  void initState() {
    _futureTopic = _getFutureTopic(widget.studyUID, widget.topicUID);
    _futureQuestion = _getFutureQuestion(
        widget.studyUID, widget.topicUID, widget.questionUID);

    _streamResponses = _getResponsesStream(
        widget.studyUID, widget.topicUID, widget.questionUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          children: [
            FutureBuilder<Topic>(
              future: _futureTopic,
              builder:
                  (BuildContext context, AsyncSnapshot<Topic> topicSnapshot) {
                if (topicSnapshot.connectionState == ConnectionState.done) {
                  return FutureBuilder<Question>(
                    future: _futureQuestion,
                    builder: (BuildContext context,
                        AsyncSnapshot<Question> questionSnapshot) {
                      if (questionSnapshot.connectionState ==
                          ConnectionState.done) {
                        return _QuestionDisplayBar(
                          studyUID: widget.studyUID,
                          topicName: topicSnapshot.data.topicName,
                          topicUID: topicSnapshot.data.topicUID,
                          questionUID: questionSnapshot.data.questionUID,
                          questionTitle: questionSnapshot.data.questionTitle,
                          questionStatement:
                              questionSnapshot.data.questionStatement,
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(
              height: 20.0,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: PROJECT_LIGHT_GREEN,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),

              child: StreamBuilder<QuerySnapshot>(
                stream: _streamResponses,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ResponseWidget(
                                studyUID: widget.studyUID,
                                topicUID: widget.topicUID,
                                questionUID: widget.questionUID,
                                response: Response.fromMap(
                                  snapshot.data.docs[index].data(),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10.0,
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              'No responses yet',
                            ),
                          );
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
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionDisplayBar extends StatefulWidget {
  final String studyUID;
  final String topicUID;
  final String questionUID;
  final String topicName;
  final String questionTitle;
  final String questionStatement;

  const _QuestionDisplayBar(
      {Key key,
      this.topicName,
      this.questionTitle,
      this.questionStatement,
      this.topicUID,
      this.questionUID,
      this.studyUID})
      : super(key: key);

  @override
  __QuestionDisplayBarState createState() => __QuestionDisplayBarState();
}

class __QuestionDisplayBarState extends State<_QuestionDisplayBar> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  Stream<DocumentSnapshot> _streamResponsesAndComments;

  Stream<DocumentSnapshot> _getResponsesAndCommentsStream(
      String studyUID, String topicUID, String questionUID) {
    return _researcherAndModeratorFirestoreService.getQuestionAsStream(
        studyUID, topicUID, questionUID);
  }

  @override
  void initState() {
    _streamResponsesAndComments = _getResponsesAndCommentsStream(
        widget.studyUID, widget.topicUID, widget.questionUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      color: Colors.grey[100],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenSize.width * 0.55,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.topicName ?? 'topicName',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.questionTitle ?? 'questionTitle',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),

                HtmlWidget(widget.questionStatement,textStyle: TextStyle(color: Colors.black),),

                // Text(
                //   widget.questionStatement ?? 'questionStatement',
                //   style: TextStyle(color: Colors.black),
                // ),
              ],
            ),
          ),
          Container(
            width: 250.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Responses',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: _streamResponsesAndComments,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            var totalResponses =
                                snapshot.data.data()['totalResponses'];
                            return Text(
                              '$totalResponses',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return Text(
                              '0',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        } else {
                          return Text(
                            '0',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
