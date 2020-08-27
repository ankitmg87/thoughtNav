import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';

class TNHomeScreen extends StatelessWidget {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () {},
                    color: Color(0xFF50D2C3),
                    child: Text(
                      'RESEARCHER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(LOGIN_SCREEN);
                    },
                    color: Color(0xFF50D2C3),
                    child: Text(
                      'PARTICIPANT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
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
  }
}
