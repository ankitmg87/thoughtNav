import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

import 'custom_text_editing_box.dart';
import 'study_setup_screen_question_widget.dart';

class StudySetupScreenTopicWidget extends StatefulWidget {
  final Function onTap;

  const StudySetupScreenTopicWidget({Key key, this.onTap}) : super(key: key);

  @override
  _StudySetupScreenTopicWidgetState createState() =>
      _StudySetupScreenTopicWidgetState();
}

class _StudySetupScreenTopicWidgetState
    extends State<StudySetupScreenTopicWidget> {
  int numberOfQuestions = 1;

  void addNumberOfQuestions() {
    setState(() {
      numberOfQuestions++;
    });
  }

  void reduceNumberOfQuestions() {
    if (numberOfQuestions > 1) {
      setState(() {
        numberOfQuestions--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
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
              Expanded(
                child: TextFormField(
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
                    onTap: widget.onTap,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        'Select Date',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  numberOfQuestions > 1
                      ? IconButton(
                    onPressed: () => reduceNumberOfQuestions(),
                    icon: Icon(
                      Icons.clear_outlined,
                    ),
                    color: Colors.red[700],
                  )
                      : SizedBox(),
                  IconButton(
                    onPressed: () => addNumberOfQuestions(),
                    icon: Icon(
                      Icons.add_circle_outlined,
                    ),
                    color: PROJECT_GREEN,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20.0,
              );
            },
            itemCount: numberOfQuestions,
            itemBuilder: (BuildContext context, int index) {
              return StudySetupScreenQuestionWidget(
                index: index + 1,
                onTap: () async {
                  await showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return CustomTextEditingBox();
                      });
                },
                hint: Text(
                  'Set a Question',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.grey[400],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}