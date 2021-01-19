import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

import 'custom_text_editing_box.dart';
import 'study_setup_screen_question_widget.dart';

class StudySetupScreenTopicWidget extends StatefulWidget {
  final String studyUID;
  final Topic topic;
  final List<Group> groups;

  const StudySetupScreenTopicWidget({
    Key key,
    this.studyUID,
    this.topic,
    this.groups,
  }) : super(key: key);

  @override
  _StudySetupScreenTopicWidgetState createState() =>
      _StudySetupScreenTopicWidgetState();
}

class _StudySetupScreenTopicWidgetState
    extends State<StudySetupScreenTopicWidget> {
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  List<Question> _questions;

  DateTime _topicDateTime;
  TimeOfDay _topicTimeOfDay;

  String _topicDate;
  String _topicTime;

  Stream<QuerySnapshot> _questionsStream;

  Stream<QuerySnapshot> _getQuestionStream(String studyUID, String topicUID) {
    return _researcherAndModeratorFirestoreService.streamQuestions(
        studyUID, topicUID);
  }

  final FocusNode _topicNumberFocusNode = FocusNode();
  final FocusNode _topicNameFocusNode = FocusNode();

  void _updateTopicDetails() async {
    await _firebaseFirestoreService.updateTopic(widget.studyUID, widget.topic);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _questions.insert(newIndex, _questions.removeAt(oldIndex));
    });
  }

  @override
  void initState() {
    super.initState();

    _topicNumberFocusNode.addListener((){
      if(!_topicNumberFocusNode.hasFocus){
        _updateTopicDetails();
      }
    });

    _topicNameFocusNode.addListener(() {
      if (!_topicNameFocusNode.hasFocus) {
        _updateTopicDetails();
      }
    });

    _questionsStream =
        _getQuestionStream(widget.studyUID, widget.topic.topicUID);

    _questions = widget.topic.questions;

    _questions ??= <Question>[];
  }

  @override
  void didChangeDependencies() {
    if (widget.topic.topicDate != null) {
      // _topicDate = _formatTopicDate(widget.topic.topicDate);
      _topicDateTime = DateTime.fromMillisecondsSinceEpoch(
          widget.topic.topicDate.millisecondsSinceEpoch);
      _topicTimeOfDay =
          TimeOfDay(hour: _topicDateTime.hour, minute: _topicDateTime.minute);

      var dateFormatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);

      _topicDate = dateFormatter.format(_topicDateTime);
      _topicTime = _topicTimeOfDay.format(context);
    }
    super.didChangeDependencies();
  }

  String _formatTopicDate(DateTime topicDateTime) {
    var formatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
    return formatter.format(topicDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        bottom: 5.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300],
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 60.0,
                child: TextFormField(
                  initialValue: widget.topic.topicNumber,
                  focusNode: _topicNumberFocusNode,
                  onFieldSubmitted: (topicNumber) {
                    if (topicNumber != null || topicNumber.isNotEmpty) {
                      _updateTopicDetails();
                    }
                  },
                  onChanged: (topicNumber) {
                    widget.topic.topicNumber = topicNumber;
                  },
                  decoration: InputDecoration(
                    hintText: 'No.',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                width: 40.0,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: widget.topic.topicName,
                  focusNode: _topicNameFocusNode,
                  onChanged: (topicName) {
                    if (topicName != null || topicName.isNotEmpty) {
                      widget.topic.topicName = topicName;
                    }
                  },
                  onFieldSubmitted: (topicName) {
                    if (topicName != null || topicName.isNotEmpty) {
                      _updateTopicDetails();
                    }
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Topic Name',
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
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
                width: 40.0,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                      width: 0.75,
                      color: Colors.grey[300],
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final beginDate = await showDatePicker(
                        firstDate: DateTime(2020),
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2025),
                        context: context,
                      );
                      if (beginDate != null) {
                        _topicDate = _formatTopicDate(beginDate);
                        _topicDateTime = beginDate;

                        if (_topicDateTime != null && _topicTimeOfDay != null) {
                          widget.topic.topicDate = Timestamp.fromDate(DateTime(
                            _topicDateTime.year,
                            _topicDateTime.month,
                            _topicDateTime.day,
                            _topicTimeOfDay.hour,
                            _topicTimeOfDay.minute,
                          ));
                          _updateTopicDetails();
                        }
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        _topicDate ?? 'Select Date',
                        style: TextStyle(
                          color: _topicDate == null
                              ? Colors.grey[400]
                              : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                      width: 0.75,
                      color: Colors.grey[300],
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        _topicTimeOfDay = time;

                        _topicTime = time.format(context);

                        if (_topicDateTime != null && _topicTimeOfDay != null) {
                          widget.topic.topicDate = Timestamp.fromDate(
                            DateTime(
                              _topicDateTime.year,
                              _topicDateTime.month,
                              _topicDateTime.day,
                              _topicTimeOfDay.hour,
                              _topicTimeOfDay.minute,
                            ),
                          );
                          _updateTopicDetails();
                        }
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        _topicTime ?? 'Select Time',
                        style: TextStyle(
                          color: _topicTime == null
                              ? Colors.grey[400]
                              : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              widget.topic.isActive
                  ? SizedBox()
                  : InkWell(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {},
                      child: Text(
                        'Delete Topic',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          widget.topic.isActive
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.topic.questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StudySetupScreenQuestionWidget(
                      studyUID: widget.studyUID,
                      topicUID: widget.topic.topicUID,
                      question: widget.topic.questions[index],
                      groups: widget.groups,
                      topicIsActive: widget.topic.isActive,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox();
                  },
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: _questionsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return SizedBox();
                        break;
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.isNotEmpty) {
                            return ReorderableWrap(
                              needsLongPressDraggable: false,
                              runSpacing: 10.0,
                              onReorder: _onReorder,
                              children: List.generate(snapshot.data.docs.length,
                                  (index) {
                                return StudySetupScreenQuestionWidget(
                                  groups: widget.groups,
                                  studyUID: widget.studyUID,
                                  topicUID: widget.topic.topicUID,
                                  question: Question.fromMap(
                                      snapshot.data.docs[index].data()),
                                  topicIsActive: widget.topic.isActive,
                                  deleteQuestion: () async {
                                    await _researcherAndModeratorFirestoreService
                                        .deleteQuestion(
                                            widget.studyUID,
                                            widget.topic.topicUID,
                                            snapshot.data.docs[index]
                                                .data()['questionUID']);
                                  },
                                );
                              }).toList(),
                            );
                          } else {
                            return SizedBox();
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
          SizedBox(
            height: 10.0,
          ),
          widget.topic.isActive
              ? SizedBox()
              : Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _questions.length > 1
                          ? InkWell(
                              onTap: () async {
                                await _firebaseFirestoreService.deleteQuestion(
                                    widget.studyUID,
                                    widget.topic.topicUID,
                                    _questions.last.questionUID);
                                setState(() {
                                  _questions.removeLast();
                                });
                              },
                              child: Text(
                                'Delete Question',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                        onTap: () async {
                          var question =
                              await _researcherAndModeratorFirestoreService
                                  .createQuestion(
                            widget.studyUID,
                            _questions.length + 1,
                            widget.topic.topicUID,
                            widget.topic.topicDate,
                          );
                          setState(() {
                            _questions.add(question);
                          });
                        },
                        child: Text(
                          'Add Question',
                          style: TextStyle(
                            color: PROJECT_GREEN,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
