import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/widgets/custom_text_editing_box.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class StudySetupScreenQuestionWidget extends StatefulWidget {
  final String studyUID;
  final String topicUID;
  final Question question;
  final Function onTap;
  final List<Group> groups;
  final Function deleteQuestion;

  const StudySetupScreenQuestionWidget({
    Key key,
    this.onTap,
    this.question,
    this.topicUID,
    this.studyUID,
    this.groups,
    this.deleteQuestion,
  }) : super(key: key);

  @override
  _StudySetupScreenQuestionWidgetState createState() =>
      _StudySetupScreenQuestionWidgetState();
}

class _StudySetupScreenQuestionWidgetState
    extends State<StudySetupScreenQuestionWidget> {
  final _researcherAndModeratorFirestoreService =
      ResearcherAndModeratorFirestoreService();

  final _questionTitleFocusNode = FocusNode();
  final _questionNumberFocusNode = FocusNode();

  String _questionStatement;
  String _questionTitle;
  String _questionNumber;

  String _questionDate;
  String _questionTime;

  int _selectedRadio;

  List<dynamic> _groups = [];
  List<dynamic> _groupNames = [];

  DateTime _questionDateTime;
  TimeOfDay _questionTimeOFDay;

  void _getInitialValues() {
    _questionNumber = widget.question.questionNumber;
    _questionTitle = widget.question.questionTitle;
    _questionStatement = widget.question.questionStatement;
    _groups = widget.question.groups;
    _groupNames = widget.question.groupNames;
  }

  @override
  void didChangeDependencies() {
    if (widget.question.questionTimestamp != null) {
      _questionDateTime = DateTime.fromMillisecondsSinceEpoch(
          widget.question.questionTimestamp.millisecondsSinceEpoch);

      _questionTimeOFDay = TimeOfDay(
          hour: _questionDateTime.hour, minute: _questionDateTime.minute);

      var dateFormatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
      _questionDate = dateFormatter.format(_questionDateTime);

      _questionTime = _questionTimeOFDay.format(context);
    }

    super.didChangeDependencies();
  }

  void _updateQuestionDetails() async {
    await _researcherAndModeratorFirestoreService.updateQuestion(
        widget.studyUID, widget.topicUID, widget.question);
  }

  void _setSelectedRadio(int value) {
    setState(() {
      _selectedRadio = value;
    });
    _setQuestionType();
  }

  void _setQuestionType() {
    switch (_selectedRadio) {
      case 1:
        widget.question.questionType = 'Standard';
        _updateQuestionDetails();
        break;
      case 2:
        widget.question.questionType = 'Uninfluenced';
        _updateQuestionDetails();
        break;
      case 3:
        widget.question.questionType = 'Private';
        _updateQuestionDetails();
        break;
    }
  }

  int _getQuestionType() {
    int questionType;

    switch (widget.question.questionType) {
      case 'Standard':
        questionType = 1;
        break;
      case 'Uninfluenced':
        questionType = 2;
        break;
      case 'Private':
        questionType = 3;
        break;
      default:
        questionType = 1;
    }

    return questionType;
  }

  @override
  void initState() {
    _selectedRadio = _getQuestionType();
    _getInitialValues();
    super.initState();
    _questionTitleFocusNode.addListener(() {
      if (_questionTitleFocusNode.hasFocus) {
        if (_questionTitle != null) {
          if (_questionTitle.isNotEmpty) {
            _updateQuestionDetails();
          }
        }
      }
    });
    _questionNumberFocusNode.addListener(() {
      if (!_questionNumberFocusNode.hasFocus) {
        if (_questionNumber != null) {
          if (_questionNumber.isNotEmpty) {
            _updateQuestionDetails();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400],
          width: 0.75,
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
                  initialValue: _questionNumber,
                  focusNode: _questionNumberFocusNode,
                  onFieldSubmitted: (questionNumber) {
                    if (questionNumber != null || questionNumber.isNotEmpty) {
                      _updateQuestionDetails();
                    }
                  },
                  onChanged: (questionNumber) {
                    _questionNumber = questionNumber;
                    widget.question.questionNumber = _questionNumber;
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
                  initialValue: _questionTitle,
                  focusNode: _questionTitleFocusNode,
                  onFieldSubmitted: (questionTitle) {
                    if (questionTitle.isNotEmpty || questionTitle != null) {
                      _questionTitle = questionTitle;
                      widget.question.questionTitle = _questionTitle;
                      _updateQuestionDetails();
                    }
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Question Title',
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
                      await showGeneralDialog(
                        context: context,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        barrierColor: Colors.black45,
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function())
                                    groupDialogSetState) {
                              return Center(
                                child: Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    padding: EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Select Groups',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Container(
                                          height: 1.0,
                                          color: Colors.grey[300],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Expanded(
                                          child: Wrap(
                                            spacing: 10.0,
                                            runSpacing: 10.0,
                                            children: List.generate(
                                                widget.groups.length, (index) {
                                              return FilterChip(
                                                elevation: 2.0,
                                                checkmarkColor: Colors.white,
                                                selectedColor: PROJECT_GREEN,
                                                selected: _groupNames.contains(
                                                    widget
                                                        .groups[index].groupName),
                                                onSelected: (bool value) {
                                                  groupDialogSetState(() {
                                                    if (value) {
                                                      _groupNames.add(widget
                                                          .groups[index]
                                                          .groupName);

                                                      _groups.add(widget
                                                          .groups[index]
                                                          .groupUID);

                                                      widget.question.groupNames =
                                                          _groupNames;

                                                      widget.question.groups =
                                                          _groups;
                                                    } else {
                                                      _groupNames.removeWhere(
                                                          (groupName) {
                                                        return groupName ==
                                                            widget.groups[index]
                                                                .groupName;
                                                      });
                                                      _groups.removeWhere(
                                                          (groupUID) {
                                                        return groupUID ==
                                                            widget.groups[index]
                                                                .groupUID;
                                                      });
                                                      widget.question.groupNames =
                                                          _groupNames;
                                                      widget.question.groups =
                                                          _groups;
                                                    }
                                                  });
                                                },
                                                label: Text(
                                                  widget.groups[index].groupName,
                                                  style: TextStyle(
                                                      color: _groupNames.contains(
                                                              widget.groups[index]
                                                                  .groupName)
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        ButtonBar(
                                          children: [
                                            RaisedButton(
                                              color: Colors.grey[300],
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 8.0),
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            RaisedButton(
                                              onPressed: _groupNames.isEmpty
                                                  ? null
                                                  : () async {
                                                      await _researcherAndModeratorFirestoreService
                                                          .updateQuestion(
                                                              widget.studyUID,
                                                              widget.topicUID,
                                                              widget.question);
                                                      Navigator.pop(context);
                                                    },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 8.0),
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              color: PROJECT_GREEN,
                                              disabledColor: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        widget.question.groups.isEmpty
                            ? 'Select groups'
                            : 'Groups Selected',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: widget.question.groups == null ||
                                  widget.question.groups.isEmpty
                              ? Colors.grey[400]
                              : Colors.grey[700],
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
                      final date = await showDatePicker(
                        context: context,
                        lastDate: DateTime(2025),
                        firstDate: DateTime(2020),
                        initialDate: DateTime.now(),
                      );
                      if (date != null) {
                        _questionDateTime = date;

                        var dateFormatter =
                            DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
                        _questionDate = dateFormatter.format(date);

                        if (_questionDateTime != null &&
                            _questionTimeOFDay != null) {
                          widget.question.questionTimestamp =
                              Timestamp.fromDate(
                            DateTime(
                              _questionDateTime.year,
                              _questionDateTime.month,
                              _questionDateTime.day,
                              _questionTimeOFDay.hour,
                              _questionTimeOFDay.minute,
                            ),
                          );
                          _updateQuestionDetails();
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
                        _questionDate ?? 'Please set a date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: _questionDate == null
                              ? Colors.grey[400]
                              : Colors.grey[700],
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
                        _questionTimeOFDay = time;

                        _questionTime = time.format(context);

                        if (_questionDateTime != null &&
                            _questionTimeOFDay != null) {
                          widget.question.questionTimestamp =
                              Timestamp.fromDate(
                            DateTime(
                              _questionDateTime.year,
                              _questionDateTime.month,
                              _questionDateTime.day,
                              _questionTimeOFDay.hour,
                              _questionTimeOFDay.minute,
                            ),
                          );
                          _updateQuestionDetails();
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
                        _questionTime ?? 'Please set a time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: _questionTime == null
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              IconButton(
                onPressed: widget.deleteQuestion,
                icon: Icon(
                  CupertinoIcons.clear_circled_solid,
                  size: 16.0,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(
                width: 0.75,
                color: Colors.grey[300],
              ),
            ),
            child: InkWell(
              onTap: () async {
                final questionStatement = await showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  barrierColor: Colors.black45,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Center(
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.75,
                          ),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          // child: EasyWebView(
                          //   src: 'assets/quill.html',
                          //   width: MediaQuery.of(context).size.width * 0.5,
                          //   height: MediaQuery.of(context).size.height * 0.5,
                          //   convertToWidgets: true,
                          //   onLoaded: () {},
                          // ),
                          child: TextFormField(
                            initialValue: _questionStatement,
                            decoration: InputDecoration(
                              hintText: 'Enter a question',
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
                      ),
                    );

                    //   CustomTextEditingBox(
                    //   hintText: 'Enter question statement',
                    //   initialValue: widget.question.questionStatement,
                    // );
                  },
                );
                if (questionStatement != null) {
                  if (questionStatement.toString().trim().isNotEmpty) {
                    _questionStatement = questionStatement.toString();
                    setState(() {
                      widget.question.questionStatement = _questionStatement;
                    });
                    _updateQuestionDetails();
                  }
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text(
                              widget.question.questionStatement == null
                                  ? 'Set a Question'
                                  : _questionStatement,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.grey[500],
                      accentColor: PROJECT_NAVY_BLUE,
                    ),
                    child: Radio(
                      value: 1,
                      groupValue: _selectedRadio,
                      onChanged: (int value) {
                        _setSelectedRadio(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Standard',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.grey[500],
                      accentColor: PROJECT_NAVY_BLUE,
                    ),
                    child: Radio(
                      value: 2,
                      groupValue: _selectedRadio,
                      onChanged: (int value) {
                        _setSelectedRadio(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Un-Influenced',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.grey[500],
                      accentColor: PROJECT_NAVY_BLUE,
                    ),
                    child: Radio(
                      value: 3,
                      groupValue: _selectedRadio,
                      onChanged: (int value) {
                        _setSelectedRadio(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Private',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: ThemeData(
                      accentColor: PROJECT_NAVY_BLUE,
                      unselectedWidgetColor: Colors.grey[300],
                    ),
                    child: Checkbox(
                      // TODO -> Change tick colour
                      value: widget.question.hasMedia,
                      onChanged: (bool value) {
                        setState(() {
                          widget.question.hasMedia = value;
                          _updateQuestionDetails();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Question has media',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssignedGroupWidget extends StatefulWidget {
  const _AssignedGroupWidget({
    Key key,
    @required this.widget,
    this.index,
    this.groups,
    this.researcherAndModeratorFirestoreService,
    this.studyUID,
    this.topicUID,
    this.questionUID,
  }) : super(key: key);

  final StudySetupScreenQuestionWidget widget;
  final int index;
  final List groups;
  final ResearcherAndModeratorFirestoreService
      researcherAndModeratorFirestoreService;
  final String studyUID;
  final String topicUID;
  final String questionUID;

  @override
  _AssignedGroupWidgetState createState() => _AssignedGroupWidgetState();
}

class _AssignedGroupWidgetState extends State<_AssignedGroupWidget> {
  bool _isSelected = false;

  String _groupUID;

  @override
  void initState() {
    _groupUID = widget.widget.groups[widget.index].groupUID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_isSelected == true) {
          setState(() {
            _isSelected = false;
            widget.groups.remove(_groupUID);
          });
          await widget.researcherAndModeratorFirestoreService
              .removeAssignedGroup(widget.studyUID, widget.topicUID,
                  widget.questionUID, _groupUID);
        } else {
          setState(() {
            _isSelected = true;
            widget.groups.add(_groupUID);
          });
          await widget.researcherAndModeratorFirestoreService.addAssignedGroup(
              widget.studyUID, widget.topicUID, widget.questionUID, _groupUID);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: _isSelected ? PROJECT_LIGHT_GREEN : Colors.white,
          border: Border.all(
            color: PROJECT_LIGHT_GREEN,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: Text(
            widget.widget.groups[widget.index].groupName,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // constraints: BoxConstraints(
        //   maxWidth: 100.0,
        //   maxHeight: 40.0,
        // ),
      ),
    );
  }
}
