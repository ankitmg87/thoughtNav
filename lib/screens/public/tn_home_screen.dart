import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';

class TNHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= screenHeight) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: PROJECT_GREEN,
          title: Text(
            APP_NAME,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            constraints: BoxConstraints(maxWidth: 600.0),
            child: Theme(
              data: ThemeData(
                accentColor: Colors.transparent,
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 362.0,
                      height: 246.0,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 55.0,
                            right: 39.0,
                            child: Image(
                              image: AssetImage(
                                'images/homescreen_images/2.png',
                              ),
                            ),
                          ),
                          Positioned(
                            top: 68,
                            left: 0,
                            bottom: 0,
                            child: Image(
                              image: AssetImage(
                                'images/homescreen_images/1.png',
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 101,
                            child: Image(
                              image: AssetImage(
                                'images/homescreen_images/3.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Focus groups. Made easy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 22.0,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(LOGIN_SCREEN),
                      color: Color(0xFF50D2C3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Why online focus groups?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'The business climate has changed. There is an urgent need to keep up with shifts in customer thinking while saving time and money. More companies are turning to online focus groups to stay up-to-date with their customer\'s mindset. ThoughtNav provides a comprehensive tool for creating and managing the entire process.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF747476),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Online focus groups cost less and participants love them. ',
                            style: TextStyle(
                              color: Color(0xFF747476),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Anyone who has used Facebook will have no problems using our ThoughtNav.',
                            style: TextStyle(
                              color: Color(0xFF747476),
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Key Features',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Abc',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: screenHeight * 0.2,
                  // ),
                  // Text(
                  //   'Try it now',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20.0,
                  //   ),
                  // ),
                  SizedBox(
                    height: screenHeight * 0.3,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ThoughtNav - Online focus groups. Made easy.\n© Copyright 2019 Aperio Insights.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF747476),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: PROJECT_GREEN,
          title: Text(
            APP_NAME,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              Text(
                'Focus groups. Made Easy',
                style: TextStyle(
                  color: TEXT_COLOR.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0, bottom: 10.0,),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Why online focus groups?',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'The business climate has changed. There is an urgent need to keep up with shifts in customer thinking while saving time and money. More companies are turning to online focus groups to stay up-to-date with their customer\'s mindset. ThoughtNav provides a comprehensive tool for creating and managing the entire process.',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF747476),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: RichText(
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Online focus groups cost less and participants love them. ',
                                    style: TextStyle(
                                      color: Color(0xFF747476),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Anyone who has used Facebook will have no problems using our ThoughtNav.',
                                    style: TextStyle(
                                      color: Color(0xFF747476),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Key Features',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.2,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Abc',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: screenHeight * 0.2,
                          // ),
                          // Text(
                          //   'Try it now',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 20.0,
                          //   ),
                          // ),
                          SizedBox(
                            height: screenHeight * 0.2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'ThoughtNav. Online focus groups. Made easy. © Copyright 2019 Aperio Insights.',
                              style: TextStyle(
                                color: Color(0xFF747476),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          width: 362.0,
                          height: 246.0,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 55.0,
                                right: 39.0,
                                child: Image(
                                  image: AssetImage(
                                    'images/homescreen_images/2.png',
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 68,
                                left: 0,
                                bottom: 0,
                                child: Image(
                                  image: AssetImage(
                                    'images/homescreen_images/1.png',
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                top: 101,
                                child: Image(
                                  image: AssetImage(
                                    'images/homescreen_images/3.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(LOGIN_SCREEN);
                            },
                            color: Color(0xFF50D2C3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 10.0,
                              ),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // SizedBox(
              //   height: 100.0,
              // ),
            ],
          ),
        ),
      );
    }
  }
}
