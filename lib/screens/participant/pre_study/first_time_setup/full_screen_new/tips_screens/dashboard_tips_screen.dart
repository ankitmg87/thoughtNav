import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DashboardTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
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
                    description: 'We need to hear the truth, even if it hurts. Your responses won\'t be linked back to you in any way.',
                    imagePath: 'images/login_screen_right.png',
                  ),
                  _TipsContainer(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    title: 'Comment on the other posts',
                    description: 'Let others know when you agree or disagree with what they have said.',
                    imagePath: 'images/dashboard_screen_3.png',
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FlatButton(

                  ),
                ),
              ],
            )
          ],
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
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                Image(
                  height: screenHeight * 0.4,
                  image: AssetImage(
                    imagePath,
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
