import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/misc_constants.dart';
import 'package:thoughtnav/screens/researcher/widgets/comment_widget.dart';

class ResponseWidget extends StatefulWidget {
  @override
  _ResponseWidgetState createState() => _ResponseWidgetState();
}

class _ResponseWidgetState extends State<ResponseWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Card(
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        'images/avatars/batman.png',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Alias - ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'User Name',
                                      style: TextStyle(
                                        color: PROJECT_GREEN,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                'Date',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Duration difference',
                            style: TextStyle(
                              color: PROJECT_GREEN,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        TEMPORARY_QUESTION,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_border_rounded,
                                color: PROJECT_GREEN,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                  color: PROJECT_GREEN
                                ),
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Icon(
                                CupertinoIcons.chat_bubble,
                                color: PROJECT_GREEN,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                    color: PROJECT_GREEN
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        CommentWidget(),
      ],
    );
  }
}
