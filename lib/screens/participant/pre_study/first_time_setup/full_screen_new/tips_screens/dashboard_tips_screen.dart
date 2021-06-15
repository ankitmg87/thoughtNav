// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';

class DashboardTipsScreen extends StatefulWidget {
  @override
  _DashboardTipsScreenState createState() => _DashboardTipsScreenState();
}

class _DashboardTipsScreenState extends State<DashboardTipsScreen> {

  int _currentPage = 0;

  final _pageController = PageController();

  String _buttonLabel = 'NEXT';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'A few tips before you begin',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.075,
              ),
              Container(
                height: screenHeight * 0.8,
                child: PageView(
                  controller: _pageController,
                  children: [
                    _TipsContainer(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Be Specific',
                      description:
                      'Tell us the reason behind your answers. Details are important!',
                      imagePath: 'images/login_screen_left.png',
                    ),
                    _TipsContainer(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Be open and honest',
                      description:
                      'We need to hear the truth, even if it hurts. Your responses won\'t be linked back to you in any way.',
                      imagePath: 'images/login_screen_right.png',
                    ),
                    _TipsContainer(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      title: 'Comment on the other posts',
                      description:
                      'Let others know when you agree or disagree with what they have said.',
                      imagePath: 'images/dashboard_screen_3.png',
                    ),
                  ],
                )
                // Carousel(
                //   dotColor: Colors.grey[400],
                //   dotBgColor: Colors.transparent,
                //   dotIncreasedColor: Colors.grey[700],
                //   autoplay: false,
                //   images: [
                //         _TipsContainer(
                //           screenHeight: screenHeight,
                //           screenWidth: screenWidth,
                //           title: 'Be Specific',
                //           description:
                //               'Tell us the reason behind your answers. Details are important!',
                //           imagePath: 'images/login_screen_left.png',
                //         ),
                //         _TipsContainer(
                //           screenHeight: screenHeight,
                //           screenWidth: screenWidth,
                //           title: 'Be open and honest',
                //           description:
                //               'We need to hear the truth, even if it hurts. Your responses won\'t be linked back to you in any way.',
                //           imagePath: 'images/login_screen_right.png',
                //         ),
                //         _TipsContainer(
                //           screenHeight: screenHeight,
                //           screenWidth: screenWidth,
                //           title: 'Comment on the other posts',
                //           description:
                //               'Let others know when you agree or disagree with what they have said.',
                //           imagePath: 'images/dashboard_screen_3.png',
                //         ),
                //   ],
                // )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: PROJECT_GREEN,
                        onPressed: (){
                          if(_currentPage == 0){
                            setState(() {
                              _currentPage = 1;
                              _pageController.jumpToPage(_currentPage);
                              _buttonLabel = 'NEXT';
                            });
                            return;
                          } else if(_currentPage == 1){
                            setState(() {
                              _currentPage = 2;
                              _pageController.jumpToPage(_currentPage);
                              _buttonLabel = 'GO TO DASHBOARD';
                            });
                            return;
                          }
                          else {
                            Navigator.of(context).pushNamedAndRemoveUntil(PARTICIPANT_DASHBOARD_SCREEN, (route) => false);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            _buttonLabel,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              // CustomFlatButton(
              //     label: 'BEGIN STUDY',
              //     routeName: PARTICIPANT_DASHBOARD_SCREEN),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipsContainer extends StatelessWidget {
  const _TipsContainer({
    Key key,
    @required this.screenHeight,
    @required this.screenWidth,
    this.imagePath,
    this.title,
    this.description,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Text(
              description,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 24.0,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Row(
              children: [
                // SizedBox(
                //   width: screenWidth * 0.05,
                // ),
                Expanded(
                  child: Image(
                    height: screenHeight * 0.4,
                    image: AssetImage(
                      imagePath,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
