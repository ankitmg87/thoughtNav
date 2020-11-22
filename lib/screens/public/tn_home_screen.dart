import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TNHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            constraints: BoxConstraints(maxWidth: 600.0),
            child: ListView(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
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
                  height: screenHeight * 0.2,
                ),
                Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(LOGIN_SCREEN),
                    color: Color(0xFF50D2C3),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                  height: screenHeight * 0.15,
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
                    'Why online focus groups?',
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
                SizedBox(
                  height: screenHeight * 0.2,
                ),
                Text(
                  'Try it now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ThoughtNav\nOnline focus groups. Made easy.\n© Copyright 2019 Aperio Insights.',
                    style: TextStyle(
                      color: Color(0xFF747476),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
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
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
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
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(40.0),
                      child: ListView(
                        children: [
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
                              'Why online focus groups?',
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
                          SizedBox(
                            height: screenHeight * 0.2,
                          ),
                          Text(
                            'Try it now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                      'images/homescreen_images/2.png'),
                                ),
                              ),
                              Positioned(
                                top: 68,
                                left: 0,
                                bottom: 0,
                                child: Image(
                                  image: AssetImage(
                                      'images/homescreen_images/1.png'),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                top: 101,
                                child: Image(
                                  image: AssetImage(
                                      'images/homescreen_images/3.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Align(
              alignment: Alignment.center,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LOGIN_SCREEN);
                  // var sendGridUtil = SendGridUtil();
                  // sendGridUtil.sendRegistrationNotification('rajas.c.9026@gmail.com');

                  // var sendGridUtil = SendGridUtil();
                  // sendGridUtil.sendEMail('thoughtnav@gmail.com');


                  // await getData1();

                },
                color: Color(0xFF50D2C3),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              height: 30.0,
            ),
          ],
        ),
      );
    }
  }

  Future<void> getData1() async {
    var client = HttpClient('http://koodo.m-staging.in/Koodo/flutter');

    var response = await client.post('/sport-list');

    print(response);

  }

  Future<void> getdata() async {

    var data = 'Request';

    var hello = await http.get(Uri.encodeFull('http://bluechipdigitech.com'),
        headers : {
          // "Accept" : "application/json"
          'Access-Control-Allow-Origin' : '*',
        }
    );

    var jsonData = convert.jsonDecode(hello.body);
    data = jsonData['title'].toString();
    var statusCode = convert.jsonDecode(hello.statusCode.toString());
    print(statusCode);


  }

}

class SendGridUtil {
  void sendEMail(String email) async {


    var data = "Request";


    // var headers = <String, String>{};
    //
    // headers['Authorization'] =
    //     'Bearer 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';
    // headers['Content-Type'] = 'application/json';
    // headers['Access-Control-Allow-Origin'] = '*';
    //
    // var _url = 'https://api.sendgrid.com/v3/mail/send';
    // var url1 = 'http://koodo.m-staging.in/Koodo/flutter/sport-list';
    //
    // var response = await http.post(
    //   url1,
    //   // headers: headers,
    //   // body: '{\n          \"personalizations\": [\n            {\n              \"to\": [\n                {\n                  \"email\": \"norequirement@gmail.com\"\n                },\n                {\n                  \"email\": \"rajas.c.9026@gmail.com\"\n                }\n              ]\n            }\n          ],\n          \"from\": {\n            \"email\": \"$email\"\n          },\n          \"subject\": \"Hello world!\",\n          \"content\": [\n            {\n              \"type\": \"text\/plain\",\n              \"value\": \"Hello from thoughtnav\"\n            }\n          ]\n        }',
    // );
    //
    // var jsonResponse = convert.jsonDecode(response.body);
    //
    // // print('RESPONSE STATUS: ${response.statusCode}');
    // print('RESPONSE BODY: ${response.body}');
  }
}

// class SendGridUtil {
//   void sendRegistrationNotification(String email) async {
//     Map<String, String> headers = new Map();
//     headers['Authorization'] =
//     'Bearer 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';
//     headers["Content-Type"] = "application/json";
//
//     var url = 'https://api.sendgrid.com/v3/mail/send';
//     var response = await http.post(url,
//         headers: headers,
//         body:
//         '{\n          \"personalizations\": [\n            {\n              \"to\": [\n                {\n                  \"email\": \"ankitmg87@gmail.com\"\n                },\n                {\n                  \"email\": \"darran@gmailxxx.com\"\n                }\n              ]\n            }\n          ],\n          \"from\": {\n            \"email\": \"norequirement@gmail.com\"\n          },\n          \"subject\": \"Hello world!\",\n          \"content\": [\n            {\n              \"type\": \"text\/plain\",\n              \"value\": \"Hello from thoughtnav\"\n            }\n          ]\n        }');
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   }
// }

// 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 send grid
