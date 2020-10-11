import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/researcher/widgets/question_tile.dart';

class TopicWidget extends StatefulWidget {
  @override
  _TopicWidgetState createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Topic Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Date',
                      style: TextStyle(
                        color: Color(0xFF7F7F7F),
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  color: PROJECT_GREEN,
                  onPressed: () => Navigator.of(context).pushNamed(
                    CLIENT_MODERATOR_RESPONSES_SCREEN,
                  ),
                  child: Text(
                    'View Responses',
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
                    Icons.person,
                    color: Colors.grey[600],
                    size: 14.0,
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Text(
                    '5/10',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.message,
                        color: Colors.grey[600],
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        '3',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: isExpanded
                  ? Text(
                      'Hide Details',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    )
                  : Text(
                      'Show Details',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    ),
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                });
              },
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Questions',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20.0,
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          QuestionTile(),
                          QuestionTile(),
                          QuestionTile(),
                          QuestionTile(),
                        ],
                      )
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
