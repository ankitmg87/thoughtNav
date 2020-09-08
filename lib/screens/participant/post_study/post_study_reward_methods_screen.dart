import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/post_study/rewards_dashboard_screen.dart';

class PostStudyRewardMethodsScreen extends StatefulWidget {
  @override
  _PostStudyRewardMethodsScreenState createState() =>
      _PostStudyRewardMethodsScreenState();
}

class _PostStudyRewardMethodsScreenState
    extends State<PostStudyRewardMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height)
      return Scaffold(
        appBar: buildPhoneAppBar(context),
        body: buildPhoneBody(screenSize),
      );
    else
      return Scaffold(
        appBar: buildPhoneAppBar(context),
        body: buildDesktopBody(screenSize),
      );
  }

  Widget buildDesktopBody(Size screenSize) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Set up a Reward Method',
                  style: TextStyle(
                    color: TEXT_COLOR,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'After you complete this study,\nyou\'ll be awarded a \$150 giftcard.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: TEXT_COLOR.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How would you like to get paid?',
                    style: TextStyle(
                      color: TEXT_COLOR,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.1,
                      vertical: 30.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: DottedBorder(
                              color: Color(0xFF797979),
                              radius: Radius.circular(20.0),
                              borderType: BorderType.RRect,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                          'images/paypal_logo.png',
                                        ),
                                        height: 30.0,
                                      ),
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Color(0xFF333333),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: DottedBorder(
                              color: Color(0xFF797979),
                              radius: Radius.circular(20.0),
                              borderType: BorderType.RRect,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                          'images/amazon_logo.png',
                                        ),
                                        height: 30.0,
                                      ),
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Color(0xFF333333),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    color: PROJECT_GREEN,
                    onPressed: () => Navigator.of(context).popAndPushNamed(REWARDS_DASHBOARD_SCREEN),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05, vertical: 10.0),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhoneBody(Size screenSize) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 40.0,
            horizontal: 30.0,
          ),
          child: Text(
            'After you complete this  study, you\'ll be awarded a \$150 giftcard.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF333333).withOpacity(0.6),
              fontSize: 14.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 30.0,
          ),
          child: Text(
            'Set up your reward method',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 100.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: DottedBorder(
                    color: Color(0xFF797979),
                    radius: Radius.circular(20.0),
                    borderType: BorderType.RRect,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage(
                                'images/paypal_logo.png',
                              ),
                              height: 30.0,
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF333333),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: DottedBorder(
                    color: Color(0xFF797979),
                    radius: Radius.circular(20.0),
                    borderType: BorderType.RRect,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage(
                                'images/amazon_logo.png',
                              ),
                              height: 30.0,
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF333333),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 15.0,
          ),
          child: Text(
            'About Reward Methods',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            'Each study has a custom reward method. If you are not able to receive payment through one of the study\'s provided method, please contact us.',
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.6),
              fontSize: 14.0,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.2),
          child: Row(
            children: [
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: PROJECT_GREEN,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Navigator.of(context)
                      .popAndPushNamed(REWARDS_DASHBOARD_SCREEN),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  AppBar buildPhoneAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF333333),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Reward Methods',
        style: TextStyle(
          color: Color(0xFF333333),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
