import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_flat_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < screenHeight)
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
          elevation: 0,
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 600.0,
            ),
            child: ListView(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 600.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'images/login_screen_left.png',
                          width: screenWidth > 800 ? screenWidth * 0.2 : 200,
                        ),
                        Image.asset(
                          'images/login_screen_right.png',
                          width: screenWidth > 800 ? screenWidth * 0.2 : 200,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  APP_NAME,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                Text(
                  'ThoughtNav is an online focus group platform.\nResearchers use ThoughtNav to get quality\ninsights from participants like you!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                GestureDetector(
                  child: Text(
                    'Learn More',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00CC66),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: screenHeight * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'New Password',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Confirm New Password',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                CustomFlatButton(
                  label: 'CONFIRM',
                  routeName: STUDY_DETAILS_SCREEN,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
              ],
            ),
          ),
        ),
      );
    else
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: PROJECT_GREEN,
          title: Text(
            APP_NAME,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: SizedBox(),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 336.0,
                          height: 198.0,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Image(
                                  image: AssetImage(
                                    'images/login_screen_left.png',
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 21.0,
                                right: 50.0,
                                bottom: 19.0,
                                child: Image(
                                  image: AssetImage(
                                    'images/login_screen_right.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          APP_NAME,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.6),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'ThoughtNav is an online focus group platform.\nResearchers use ThoughtNav to get quality\ninsights from participants like you!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          child: Text(
                            'Learn More',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF00CC66),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: screenWidth * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reset Password',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.6),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'New Password',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.solid,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'Confirm New Password',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.solid,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: FlatButton(
                              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(LOGIN_SCREEN, (route) => false),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  'CONFIRM',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                              color: Color(0xFF27a6b6),
                            ),
                          )
                        ],
                      ),
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
