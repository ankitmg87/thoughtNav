import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';
import 'package:thoughtnav/screens/researcher/widgets/topic_widget.dart';

class DraftTopicWidget extends StatefulWidget {

  @override
  _DraftTopicWidgetState createState() => _DraftTopicWidgetState();
}

class _DraftTopicWidgetState extends State<DraftTopicWidget> {
  int numberOfQuestions = 1;

  final Topic topic = Topic();
  final List<Question> questions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return 'Please enter a topic name';
                  else {
                    if (topic.topicName.isNotEmpty) {

                    }
                    return null;
                  }
                },
                onChanged: (topicName) {
                  topic.topicName = topicName;
                },
                cursorColor: PROJECT_NAVY_BLUE,
                decoration: InputDecoration(
                  labelText: 'Topic Name',
                  labelStyle: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  child: Text(
                    'Select Date',
                  ),
                ),
              ),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: numberOfQuestions,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10.0,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return DraftQuestionWidget(
              topic: topic,
              index: index,
            );
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            numberOfQuestions > 1
                ? InkWell(
                    onTap: () {
                      // if (widget.questions.isNotEmpty &&
                      //     widget.questions.length > 1) {
                      //   widget.questions.removeLast();
                      // }
                      setState(() {
                        numberOfQuestions--;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.red[800],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.clear,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              width: 5.0,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  numberOfQuestions++;
                });
              },
              child: Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: PROJECT_GREEN,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.add_circled,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DraftQuestionWidget extends StatefulWidget {

  final int index;
  final Topic topic;

  const DraftQuestionWidget({
    Key key, this.topic, this.index,
  }) : super(key: key);

  @override
  _DraftQuestionWidgetState createState() => _DraftQuestionWidgetState();
}

class _DraftQuestionWidgetState extends State<DraftQuestionWidget> {
  final Question question = Question();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Please set a question name';
            } else {
              widget.topic.questions.insert(widget.index, question);
              return null;
            }
          },
          onChanged: (questionTitle) {
            question.questionTitle = questionTitle;
          },
          decoration: InputDecoration(
            labelText: 'Question Name',
            labelStyle: TextStyle(
              color: Colors.black45,
            ),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please set a question';
                    } else {
                      widget.topic.questions.insert(widget.index, question);
                      return null;
                    }
                  },
                  onChanged: (questionStatement) {
                    question.question = questionStatement;
                  },
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Question',
                    hintStyle: TextStyle(
                      color: Colors.black45,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.all(4.0),
                color: PROJECT_NAVY_BLUE.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Radio Group Here',
                    ),
                    Text(
                      'Assign to groups here',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
