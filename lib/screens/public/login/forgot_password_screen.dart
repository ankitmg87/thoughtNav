import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
      body: ListView(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.4,
              child: Stack(
                children: [
                  Positioned(
                      child: Image(
                        width: screenWidth * 0.5,
                        image: AssetImage(
                            'images/login_screen_left.png'
                        ),
                      ),
                      left: 20.0
                  ),
                  Positioned(
                    right: 20.0,
                    top: 20.0,
                    child: Image(
                      width: screenWidth * 0.5,
                      image: AssetImage(
                          'images/login_screen_right.png'
                      ),
                    ),
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
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Enter the six-digit code sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 20.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CustomOtpField(),
              _CustomOtpField(),
              _CustomOtpField(),
              _CustomOtpField(),
              _CustomOtpField(),
              _CustomOtpField(),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 20.0),
            child: OutlineButton(
              borderSide: BorderSide(
                color: Color(0xFF50D2C3),
                width: 2.0,
              ),
              color: PROJECT_GREEN,
              highlightColor: PROJECT_GREEN,
              highlightedBorderColor: PROJECT_GREEN,
              onPressed: (){
                Navigator.of(context).pushNamed(RESET_PASSWORD_SCREEN);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'CONFIRM',
                  style: TextStyle(
                    color: Color(0xFF50D2C3),
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CustomOtpField extends StatelessWidget {
  const _CustomOtpField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.0, color: Colors.grey,)
      ),
      child: Center(
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true
          ),
        ),
      ),
    );
  }
}
