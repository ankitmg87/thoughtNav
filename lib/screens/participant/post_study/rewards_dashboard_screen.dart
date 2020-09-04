import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/open_study/common_widgets/common_app_bar.dart';

class RewardsDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CommonAppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Card(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Power Wheelchair Study',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.8),
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'View Welcome Message',
                      style: TextStyle(
                        color: PROJECT_GREEN,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 10.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: PROJECT_GREEN,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '100 %',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PROJECT_GREEN,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'All Questions Completed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.7),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.1,
              vertical: 20.0,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 20.0,
              color: Colors.black,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(30.0),
                child: Image(
                  height: screenSize.height * 0.2,
                  image: AssetImage(
                    'images/amazon_a_logo.png',
                  ),
                ),
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.8),
                fontSize: 14.0,
              ),
              children: [
                TextSpan(
                  text: '\$150',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' Amazon Giftcard',
                ),
              ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          width: 20.0,
                          image: AssetImage(
                            'images/reward_icons/reward_icon.png',
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Claim Your Reward',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(STUDY_ENDED),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50.0,),
        ],
      ),
    );
  }
}
