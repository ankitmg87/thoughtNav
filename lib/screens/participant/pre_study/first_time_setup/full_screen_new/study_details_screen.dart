import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thoughtnav/constants/routes/routes.dart';

import 'full_screen_new_widgets/custom_flat_button.dart';

class StudyDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600.0
          ),
          child: ListView(
            children: [
              SizedBox(
                height: screenHeight * 0.075,
              ),
              Text(
                'Welcome to\nPower Wheelchair Study',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'Thank you for joining our study on power wheel chairs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'Your participation is important.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 20.0,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.1, horizontal: 40.0),
                color: Color(0xFFDFE2ED),
                padding: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DetailsRow(
                      icon: 'images/svg_icons/calender_icon.png',
                      detail: 'This study runs Monday, May 6 through Friday, May 10.',
                    ),
                    SizedBox(
                      height: 36.0,
                    ),
                    _DetailsRow(
                      icon: 'images/svg_icons/checkbox_icon.png',
                      detail: 'Login each day and post responses to the questions.',
                    ),
                    SizedBox(
                      height: 36.0,
                    ),
                    _DetailsRow(
                      icon: 'images/svg_icons/message_icon.png',
                      detail: 'All posts are anonymous. Your personal info is confidential.',
                    ),
                    SizedBox(
                      height: 36.0,
                    ),
                    _DetailsRow(
                      icon: 'images/svg_icons/amazon_icon.png',
                      detail: 'After you complete this study, you\'ll be awarded a \$150 giftcard.',
                    ),
                  ],
                ),
              ),
              CustomFlatButton(
                label: 'Let\'s Get Started',
                routeName: SELECT_AVATAR_SCREEN,
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _DetailsRow extends StatelessWidget {

  final String icon;
  final String detail;

  const _DetailsRow({
    Key key, this.icon, this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       Image.asset(icon),
        SizedBox(
          width: 24.0,
        ),
        Expanded(
          child: Text(
            detail,
            style: TextStyle(
              color: Color(0xFF0B0B0B),
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
