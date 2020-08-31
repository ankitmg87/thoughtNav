import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class StudyDetailsBottomSheet extends StatelessWidget {
  const StudyDetailsBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        right: 20.0,
      ),
      color: Colors.black38.withOpacity(0.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Study Details',
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                  ),
                )
              ],
            ),
            Divider(),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 5.0, bottom: 20.0),
                    child: Text(
                      'You\'re participating in the Power Wheelchair Study.',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Image(
                          width: 30.0,
                          image: AssetImage(
                            'images/svg_icons/calender_icon.png',
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'This study begins ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              TextSpan(
                                text: 'Monday, May 6\n',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'and ends ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              TextSpan(
                                text: 'Friday, May 10.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Image(
                          width: 30.0,
                          image: AssetImage(
                            'images/svg_icons/amazon_icon.png',
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'After you complete this study,\nyou\'ll be awarded a ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              TextSpan(
                                text: '\$150 giftcard.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.grey[200],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Text(
                      'About Power Wheelchair Study',
                      style: TextStyle(
                        color: Color(0xFF7F7F7F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'The purpose of this study is to receive your honest feedback about your personal experiences with your power wheelchair.',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      'Learn more about Focus Groups',
                      style: TextStyle(
                        color: PROJECT_GREEN,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.grey[200],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 12.0, bottom: 6.0),
                    child: Text(
                      'Tips for completing this study',
                      style: TextStyle(
                        color: Color(0xFF7F7F7F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF81D3F8),
                          size: 14.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Login each day and respond to questions.',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF81D3F8),
                          size: 14.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Login each day and respond to questions.',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF81D3F8),
                          size: 14.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Login each day and respond to questions.',
                          style: TextStyle(
                            color: PROJECT_GREEN,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.grey[200],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 12.0, bottom: 6.0),
                    child: Text(
                      'Be sure to remember...',
                      style: TextStyle(
                        color: Color(0xFF7F7F7F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF81D3F8),
                          size: 14.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Login each day and respond to questions.',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF81D3F8),
                          size: 14.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Login each day and respond to questions.',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF81D3F8),
                          size: 14.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'Login each day and respond to questions.',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 40.0,
                      horizontal: 20.0,
                    ),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Contact Us ',
                          style: TextStyle(
                            color: PROJECT_GREEN,
                            fontSize: 13.0,
                          ),
                        ),
                        TextSpan(
                          text: 'for any additional questions or concerns',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 13.0,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
