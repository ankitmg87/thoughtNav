import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/common_widgets/common_app_bar.dart';

class RewardsDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (screenSize.width < screenSize.height)
      return Scaffold(
        appBar: CommonAppBar(),
        body: buildPhoneBody(screenSize, context),
      );
    else
      return Scaffold(
        appBar: buildDesktopAppBar(),
        body: buildDesktopBody(context, screenSize),
      );
  }

  Widget buildDesktopBody(BuildContext context, Size screenSize) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Power Wheelchair Study',
                      style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.8),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Study yet to be completed',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.7),
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        minHeight: 10.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(PROJECT_GREEN),
                        backgroundColor: PROJECT_LIGHT_GREEN,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '70%',
                        style: TextStyle(
                          color: PROJECT_GREEN,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '4 days completed',
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.7),
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _DayAndDayStatusWidget(
                          title: 'Quick Intro',
                          completed: true,
                        ),
                        _DayAndDayStatusWidget(
                          title: 'Day One',
                          completed: true,
                        ),
                        _DayAndDayStatusWidget(
                          title: 'Day Two',
                          completed: true,
                        ),
                        _DayAndDayStatusWidget(
                          title: 'Day Three',
                          completed: true,
                        ),
                        _DayAndDayStatusWidget(
                          title: 'Day Four',
                          completed: true,
                        ),
                        _DayAndDayStatusWidget(
                          title: 'Day Five',
                          completed: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      SizedBox(
                        height: 30.0,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        color: PROJECT_GREEN,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
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
                        ),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(STUDY_ENDED),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar buildDesktopAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Text(
        APP_NAME,
        style: TextStyle(
          color: TEXT_COLOR,
        ),
      ),
      actions: [
        Center(
          child: Text(
            'Hello Sarah',
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.7),
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(6.0),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PROJECT_LIGHT_GREEN,
            ),
            child: Image(
              width: 20.0,
              image: AssetImage('images/avatars/batman.png'),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  ListView buildPhoneBody(Size screenSize, BuildContext context) {
    return ListView(
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
        SizedBox(
          height: 50.0,
        ),
      ],
    );
  }
}

class _DayAndDayStatusWidget extends StatelessWidget {
  const _DayAndDayStatusWidget({
    Key key,
    this.title,
    this.completed,
  }) : super(key: key);

  final String title;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: TEXT_COLOR.withOpacity(0.7),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.check_circle_outline,
            color: completed ? PROJECT_GREEN : TEXT_COLOR.withOpacity(0.3),
            size: 20.0,
          )
        ],
      ),
    );
  }
}
