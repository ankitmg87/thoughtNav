import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

class AddQuestionWidget extends StatefulWidget {
  final TextEditingController topicNameController;
  final TextEditingController questionNameController;
  final TextEditingController questionController;
  final Topic topic;
  final List<Topic> topics;

  const AddQuestionWidget({
    Key key,
    this.topicNameController,
    this.questionNameController,
    this.questionController,
    this.topic,
    this.topics,
  }) : super(key: key);

  @override
  _AddQuestionWidgetState createState() => _AddQuestionWidgetState();
}

class _AddQuestionWidgetState extends State<AddQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.topicNameController,
                  cursorColor: PROJECT_NAVY_BLUE,
                  decoration: InputDecoration(
                      labelText: 'Topic Name',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                      )),
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
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: Text(
                      'Select Date',
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: widget.questionNameController,
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
                    controller: widget.questionController,
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
      ),
    );
  }
}
