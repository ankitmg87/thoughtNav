import 'package:flutter/material.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/widgets/custom_text_editing_box.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class StudySetupScreenQuestionWidget extends StatefulWidget {
  final String studyUID;
  final String topicUID;
  final Question question;
  final Function onTap;
  final Widget hint;

  const StudySetupScreenQuestionWidget(
      {Key key,
      this.onTap,
      this.hint,
      this.question,
      this.topicUID,
      this.studyUID})
      : super(key: key);

  @override
  _StudySetupScreenQuestionWidgetState createState() =>
      _StudySetupScreenQuestionWidgetState();
}

class _StudySetupScreenQuestionWidgetState
    extends State<StudySetupScreenQuestionWidget> {
  final _firebaseFirestoreService = FirebaseFirestoreService();

  final _questionTitleFocusNode = FocusNode();

  String _questionStatement;
  String _questionTitle;

  void _getInitialValues() {
    _questionTitle = widget.question.questionTitle;
    _questionStatement = widget.question.questionStatement;
  }

  void _updateQuestionDetails() async {
    await _firebaseFirestoreService.updateQuestion(
        widget.studyUID, widget.topicUID, widget.question);
  }

  @override
  void initState() {
    super.initState();
    _questionTitleFocusNode.addListener(() {
      if (_questionTitleFocusNode.hasFocus) {
        _updateQuestionDetails();
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
              Text(
                '1.${widget.question.questionIndex}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: TextFormField(
                  focusNode: _questionTitleFocusNode,
                  onFieldSubmitted: (questionTitle){
                    widget.question.questionTitle = questionTitle;
                    _updateQuestionDetails();
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
                          return CustomTextEditingBox(
                            hintText: 'Enter question statement',
                            initialValue: widget.question.questionStatement,
                          );
                        },
                      );
                      _questionStatement = questionStatement.toString();
                      widget.question.questionStatement = _questionStatement;
                      _updateQuestionDetails();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: widget.hint ?? SizedBox(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
