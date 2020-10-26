import 'package:flutter/material.dart';

class StudySetupScreenQuestionWidget extends StatefulWidget {
  final int index;
  final Function onTap;
  final Widget hint;

  const StudySetupScreenQuestionWidget(
      {Key key, @required this.index, this.onTap, this.hint})
      : super(key: key);

  @override
  _StudySetupScreenQuestionWidgetState createState() =>
      _StudySetupScreenQuestionWidgetState();
}

class _StudySetupScreenQuestionWidgetState
    extends State<StudySetupScreenQuestionWidget> {
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
                '1.${widget.index}',
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
                    onTap: widget.onTap,
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