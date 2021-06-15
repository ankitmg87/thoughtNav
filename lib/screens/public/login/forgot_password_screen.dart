// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/services/firebase_auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _firebaseAuthService = FirebaseAuthService();

  String _email;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    if (screenWidth < screenHeight) {
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
                  height: 30.0,
                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 600.0,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 600.0,
                          height: 250.0,
                        ),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          child: Image.asset(
                            'images/login_screen_left.png',
                            width: 175.0,
                          ),
                        ),
                        Positioned(
                          bottom: 5.0,
                          right: 0.0,
                          child: Image.asset(
                            'images/login_screen_right.png',
                            width: 175.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
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
                  'ThoughtNav is an online focus group platform.'
                      '\nResearchers use ThoughtNav to get quality'
                      '\ninsights from participants like you!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Enter your valid email id',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    onChanged: (email) {
                      if (email
                          .trim()
                          .isNotEmpty) {
                        _email = email;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlineButton(
                          borderSide: BorderSide(
                            color: Color(0xFF50D2C3),
                            width: 6.0,
                            style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          onPressed: () async {
                            await _firebaseAuthService.resetPassword(_email);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'CONFIRM',
                              style: TextStyle(
                                color: Color(0xFF50D2C3),
                                fontSize: 20.0,
                              ),
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
              ],
            ),
          ),
        ),
      );
    } else {
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
                          'ThoughtNav is an online focus group platform.'
                              '\nResearchers use ThoughtNav to get quality'
                              '\ninsights from participants like you!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Forgot Your Password?',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Enter your valid email id',
                            style: TextStyle(
                              color: TEXT_COLOR.withOpacity(0.7),
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            onChanged: (email) {
                              if (email
                                  .trim()
                                  .isNotEmpty) {
                                _email = email;
                              }
                            },
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          OutlineButton(
                            onPressed: () async {
                              await _firebaseAuthService.resetPassword(_email);
                              Navigator.pop(context);
                            },
                            borderSide: BorderSide(
                                color: Color(0xFF50D2C3),
                                width: 2.0
                            ),
                            color: Color(0xFF50D2C3),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'CONFIRM',
                                style: TextStyle(
                                  color: TEXT_COLOR,
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
            ),
          ],
        ),
      );
    }
  }
}

// class _CustomOtpField extends StatelessWidget {
//   const _CustomOtpField({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40.0,
//       height: 40.0,
//       margin: EdgeInsets.symmetric(horizontal: 8.0),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//           border: Border.all(
//             width: 1.0,
//             color: Colors.grey,
//           )),
//       child: Center(
//         child: TextField(
//           textAlign: TextAlign.center,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             LengthLimitingTextInputFormatter(1),
//           ],
//           decoration: InputDecoration(border: InputBorder.none, isDense: true),
//         ),
//       ),
//     );
//   }
// }
