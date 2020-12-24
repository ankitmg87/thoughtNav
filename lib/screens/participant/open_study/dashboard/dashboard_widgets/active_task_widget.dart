import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

class ActiveTaskWidget extends StatefulWidget {
  final Topic topic;
  final String participantUID;

  const ActiveTaskWidget({Key key, @required this.topic, this.participantUID})
      : super(key: key);

  @override
  _ActiveTaskWidgetState createState() => _ActiveTaskWidgetState();
}

class _ActiveTaskWidgetState extends State<ActiveTaskWidget> {
  bool _isExpanded = false;

  int _answeredQuestions() {
    var answeredQuestions = 0;

    for (var question in widget.topic.questions) {
      if (question.respondedBy != null) {
        if (question.respondedBy.contains(widget.participantUID)) {
          answeredQuestions++;
        }
      }
    }
    return answeredQuestions;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        elevation: 4.0,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.topic.topicName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FlatButton(
                    color: PROJECT_GREEN,
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(
                        PARTICIPANT_RESPONSES_SCREEN,
                        arguments: {
                          'topicUID': widget.topic.topicUID,
                          'questionUID':
                              widget.topic.questions.first.questionUID,
                        },
                      );
                    },
                    child: Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFFDFE2ED).withOpacity(0.2),
              child: ExpansionTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list,
                      size: 14.0,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      '${_answeredQuestions()} / ${widget.topic.questions.length}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: _isExpanded
                    ? Text(
                        'Hide Details',
                        style: TextStyle(
                          color: Color(0xFFC6C5CC),
                          fontSize: 10.0,
                        ),
                      )
                    : Text(
                        'Show Details',
                        style: TextStyle(
                          color: Color(0xFFC6C5CC),
                          fontSize: 10.0,
                        ),
                      ),
                onExpansionChanged: (value) {
                  setState(() {
                    _isExpanded = value;
                  });
                },
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0, bottom: 15.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Questions',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              _answeredQuestions() ==
                                      widget.topic.questions.length
                                  ? 'All Questions Answered'
                                  : 'In Progress',
                              style: TextStyle(
                                color: Color(0xFFAAAAAA),
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 1.0,
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.topic.questions.length,
                          itemBuilder: (BuildContext context, int index) {
                            var timestamp = Timestamp.now();
                            if (index == 0 &&
                                timestamp.millisecondsSinceEpoch >=
                                    widget
                                        .topic
                                        .questions[index]
                                        .questionTimestamp
                                        .millisecondsSinceEpoch) {
                              return ActiveQuestionWidget(
                                question: widget.topic.questions[index],
                                participantUID: widget.participantUID,
                                topicUID: widget.topic.topicUID,
                              );
                            } else if (index == 0 &&
                                timestamp.millisecondsSinceEpoch <
                                    widget
                                        .topic
                                        .questions[index]
                                        .questionTimestamp
                                        .millisecondsSinceEpoch) {
                              return LockedQuestionWidget();
                            } else {
                              if (widget
                                      .topic.questions[index - 1].respondedBy !=
                                  null) {
                                if (widget
                                    .topic.questions[index - 1].respondedBy
                                    .contains(widget.participantUID)) {
                                  if (timestamp.millisecondsSinceEpoch >=
                                      widget
                                          .topic
                                          .questions[index]
                                          .questionTimestamp
                                          .millisecondsSinceEpoch) {
                                    return ActiveQuestionWidget(
                                      question: widget.topic.questions[index],
                                      participantUID: widget.participantUID,
                                      topicUID: widget.topic.topicUID,
                                    );
                                  } else {
                                    return LockedQuestionWidget();
                                  }
                                } else {
                                  return LockedQuestionWidget();
                                }
                              } else {
                                return LockedQuestionWidget();
                              }
                            }

                            // return
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10.0,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveQuestionWidget extends StatelessWidget {
  final Question question;
  final String participantUID;
  final String topicUID;

  const ActiveQuestionWidget(
      {Key key, this.question, this.participantUID, this.topicUID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).popAndPushNamed(
          PARTICIPANT_RESPONSES_SCREEN,
          arguments: {
            'topicUID': topicUID,
            'questionUID': question.questionUID,
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${question.questionNumber} ${question.questionTitle}',
            style: TextStyle(
              color: PROJECT_GREEN,
              fontSize: 12.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              question.respondedBy == null
                  ? Icons.arrow_forward
                  : question.respondedBy.contains(participantUID)
                      ? Icons.check_circle_outline_rounded
                      : Icons.arrow_forward,
              color: PROJECT_GREEN,
              size: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}

class LockedQuestionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Question Locked',
          style: TextStyle(
            color: TEXT_COLOR,
            fontSize: 12.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            Icons.lock,
            color: TEXT_COLOR.withOpacity(0.7),
            size: 16.0,
          ),
        ),
      ],
    );
  }
}
