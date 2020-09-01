import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/questions/quick_intro_tutorial/quick_intro_tutorial_widgets/comment_widget.dart';

import 'quick_intro_tutorial_widgets/user_post_widget.dart';

class TellUsYouStoryScreen extends StatefulWidget {
  @override
  _TellUsYouStoryScreenState createState() => _TellUsYouStoryScreenState();
}

class _TellUsYouStoryScreenState extends State<TellUsYouStoryScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          APP_NAME,
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 10.0,
            color: PROJECT_GREEN.withOpacity(0.4),
          ),
          Stack(
            children: [
              Positioned(
                bottom: 0,
                left: screenSize.width * 0.1,
                child: Transform.rotate(
                  angle: 0.785398,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    color: PROJECT_NAVY_BLUE,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  bottom: 30.0,
                  top: 20.0,
                ),
                width: screenSize.width,
                color: PROJECT_NAVY_BLUE,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smartphone Study',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      '01. Tell Us Your Story',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 25.0,
                        ),
                        Column(
                          children: [
                            Text(
                              'Thanks for joining us! The study officially starts today, Friday, Oct 1.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'To test the system, please tell us about yourself in a few sentences.\nPlease include any details about work, family, pets, hobbies, etc. ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
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
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image(
                  width: 16.0,
                  image: AssetImage(
                    'images/eye_icon.png',
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  'Will be visible to Everyone',
                  style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.6),
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 8.0, bottom: 20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PROJECT_LIGHT_GREEN,
                              ),
                              child: Center(
                                child: Image(
                                  width: 20.0,
                                  image: AssetImage(
                                    'images/avatars/batman.png',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Batman (me)',
                              style: TextStyle(
                                color: TEXT_COLOR.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.0)),
                          child: TextField(
                            maxLines: 3,
                            minLines: 3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write your response',
                              hintStyle: TextStyle(
                                color: TEXT_COLOR.withOpacity(0.4),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                              angle: 2.35619,
                              child: Icon(
                                Icons.attach_file,
                                color: PROJECT_GREEN,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Add an attachment',
                              style: TextStyle(
                                  color: TEXT_COLOR.withOpacity(0.4),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
                          ),
                          color: PROJECT_GREEN,
                          child: InkWell(
                            highlightColor: Colors.black.withOpacity(0.2),
                            splashColor: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All responses',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.5),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sort By',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Recent',
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Transform.rotate(
                            angle: 1.5708,
                            child: Icon(
                              CupertinoIcons.right_chevron,
                              color: Colors.lightBlue,
                              size: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          UserPostWidget(
            hasImage: true,
            screenSize: screenSize,
          ),
          CommentWidget(),
          UserPostWidget(hasImage: false, screenSize: screenSize),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(QUICK_INTRO_COMPLETE_SCREEN),
                    color: PROJECT_GREEN,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }
}
