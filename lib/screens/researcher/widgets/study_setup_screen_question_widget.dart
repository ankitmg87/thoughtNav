import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/widgets/custom_text_editing_box.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class StudySetupScreenQuestionWidget extends StatefulWidget {
  final String studyUID;
  final String topicUID;
  final Question question;
  final Function onTap;

  const StudySetupScreenQuestionWidget(
      {Key key, this.onTap, this.question, this.topicUID, this.studyUID})
      : super(key: key);

  @override
  _StudySetupScreenQuestionWidgetState createState() =>
      _StudySetupScreenQuestionWidgetState();
}

class _StudySetupScreenQuestionWidgetState
    extends State<StudySetupScreenQuestionWidget> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  final _questionTitleFocusNode = FocusNode();
  final _questionNumberFocusNode = FocusNode();

  String _questionStatement;
  String _questionTitle;
  String _questionNumber;

  int _selectedRadio;

  void _getInitialValues() {
    _questionNumber = widget.question.questionNumber;
    _questionTitle = widget.question.questionTitle;
    _questionStatement = widget.question.questionStatement;
  }

  void _updateQuestionDetails() async {
    await _firebaseFirestoreService.updateQuestion(
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
      padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      final questionStatement = await showGeneralDialog(
                        context: context,
                        barrierLabel: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        barrierColor: Colors.black45,
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return CustomTextEditingBox(
                            hintText: 'Enter question statement',
                            initialValue: widget.question.questionStatement,
                          );
                        },
                      );
                      if (questionStatement != null) {
                        if (questionStatement.toString().trim().isNotEmpty) {
                          _questionStatement = questionStatement.toString();
                          setState(() {
                            widget.question.questionStatement =
                                _questionStatement;
                          });
                          _updateQuestionDetails();
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        widget.question.questionStatement == null
                            ? 'Set a Question'
                            : 'Question set',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: widget.question.questionStatement == null
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
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
        ],
      ),
    );
  }
}
