// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/active_question_expansion_tile_child.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class EndDrawerExpansionTile extends StatefulWidget {
  const EndDrawerExpansionTile({
    Key key,
    this.title,
    this.questions,
    this.participantUID,
    this.topicUID,
  }) : super(key: key);

  final String title;
  final List<Question> questions;
  final String participantUID;
  final String topicUID;

  @override
  _EndDrawerExpansionTileState createState() => _EndDrawerExpansionTileState();
}

class _EndDrawerExpansionTileState extends State<EndDrawerExpansionTile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: _isExpanded ? 0.0 : 6.0),
      child: Column(
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            tilePadding:
                EdgeInsets.only(right: 16.0, left: _isExpanded ? 16.0 : 10.0),
            title: Text(
              widget.title,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            trailing: _isExpanded
                ? Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  )
                : Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  ),
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
            },
            children: List.generate(widget.questions.length, (index) {
              if (index == 0) {
                return ActiveQuestionExpansionTileChild(
                  question: widget.questions[index],
                  participantUID: widget.participantUID,
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(
                        PARTICIPANT_RESPONSES_SCREEN,
                        arguments: {
                          'topicUID': widget.topicUID,
                          'questionUID': widget.questions[index].questionUID,
                        });
                  },
                );
              } else {
                if (widget.questions[index - 1].respondedBy != null) {
                  if (widget.questions[index - 1].respondedBy
                      .contains(widget.participantUID) ||
                      widget.questions[index].isProbe) {
                    return ActiveQuestionExpansionTileChild(
                      question: widget.questions[index],
                      participantUID: widget.participantUID,
                      onTap: () {
                        Navigator.of(context).popAndPushNamed(
                            PARTICIPANT_RESPONSES_SCREEN,
                            arguments: {
                              'topicUID': widget.topicUID,
                              'questionUID':
                              widget.questions[index].questionUID,
                            });
                      },
                    );
                  } else {
                    return LockedQuestionExpansionTileChild(
                      question: widget.questions[index],
                    );
                  }
                } else {
                  return LockedQuestionExpansionTileChild(
                    question: widget.questions[index],
                  );
                }
              }
            }).toList(),
            // [
            //   ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: widget.questions.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       if (index == 0) {
            //         return ActiveQuestionExpansionTileChild(
            //           question: widget.questions[index],
            //           participantUID: widget.participantUID,
            //           onTap: () {
            //             Navigator.of(context).popAndPushNamed(
            //                 PARTICIPANT_RESPONSES_SCREEN,
            //                 arguments: {
            //                   'topicUID': widget.topicUID,
            //                   'questionUID':
            //                       widget.questions[index].questionUID,
            //                 });
            //           },
            //         );
            //       } else {
            //         if (widget.questions[index - 1].respondedBy != null) {
            //           if (widget.questions[index - 1].respondedBy
            //                   .contains(widget.participantUID) ||
            //               widget.questions[index].isProbe) {
            //             return ActiveQuestionExpansionTileChild(
            //               question: widget.questions[index],
            //               participantUID: widget.participantUID,
            //               onTap: () {
            //                 Navigator.of(context).popAndPushNamed(
            //                     PARTICIPANT_RESPONSES_SCREEN,
            //                     arguments: {
            //                       'topicUID': widget.topicUID,
            //                       'questionUID':
            //                           widget.questions[index].questionUID,
            //                     });
            //               },
            //             );
            //           } else {
            //             return LockedQuestionExpansionTileChild(
            //               question: widget.questions[index],
            //             );
            //           }
            //         } else {
            //           return LockedQuestionExpansionTileChild(
            //             question: widget.questions[index],
            //           );
            //         }
            //       }
            //     },
            //   ),
            // ],
          ),
          Container(
            height: 0.5,
            width: double.infinity,
            color: Color(0xFF888888).withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
