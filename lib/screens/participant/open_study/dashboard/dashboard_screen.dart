import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/misc_constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (size.width < size.height)
      return Scaffold(
        appBar: buildPhoneAppBar(),
        body: Column(
          children: [
            DashboardTopContainer(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ActiveTaskWidget(),
                  LockedTaskWidget(),
                ],
              ),
            ),
          ],
        ),
      );
    else
      return Scaffold(
        appBar: buildDesktopAppBar(),
      );
  }

  AppBar buildPhoneAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'ThoughtNav',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xFFB6ECC7),
          shape: BoxShape.circle,
        ),
        child: Image(
          image: AssetImage('images/avatars/batman.png'),
        ),
      ),
    );
  }

  AppBar buildDesktopAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'Desktop',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: Container(
        decoration: BoxDecoration(
          color: Color(0xFFB6ECC7),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class DashboardTopContainer extends StatelessWidget {
  const DashboardTopContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: COMMON_PADDING,
      color: Color(0xFF092A66),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Power Wheelchair Study',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    color: PROJECT_GREEN,
                  ),
                ),
                Icon(
                  CupertinoIcons.right_chevron,
                  color: PROJECT_GREEN,
                  size: 10.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              StartProgressContainer(),
              MiddleProgressContainer(),
              MiddleProgressContainer(),
              EndProgressContainer(),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'You have not completed any questions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              GestureDetector(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next: Quick Intro',
                      style: TextStyle(
                        color: PROJECT_GREEN,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: PROJECT_GREEN,
                      size: 10.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTabBar()
        ],
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTab(),
        CustomTab(),
        CustomTab(),
      ],
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'Remaining',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartProgressContainer extends StatelessWidget {
  const StartProgressContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(1.0),
        height: 10.0,
        decoration: BoxDecoration(
          color: Color(0xFFDFE2ED).withOpacity(0.5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class MiddleProgressContainer extends StatelessWidget {
  const MiddleProgressContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(0.5),
        height: 10.0,
        color: Color(0xFFDFE2ED).withOpacity(0.5),
      ),
    );
  }
}

class EndProgressContainer extends StatelessWidget {
  const EndProgressContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(1.0),
        height: 10.0,
        decoration: BoxDecoration(
          color: Color(0xFFDFE2ED).withOpacity(0.5),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class ActiveTaskWidget extends StatefulWidget {
  @override
  _ActiveTaskWidgetState createState() => _ActiveTaskWidgetState();
}

class _ActiveTaskWidgetState extends State<ActiveTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Card(
        elevation: 4.0,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Intro',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Pre Study',
                          style: TextStyle(
                            color: Color(0xFF7F7F7F),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      color: PROJECT_GREEN,
                      onPressed: () {},
                      child: Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5.0,
                ),
                color: Color(0xFFDFE2ED).withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_sharp,
                          color: Color(0xFFC6C5CC),
                          size: 12.0,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          '0/1',
                          style: TextStyle(
                            color: Color(0xFFC6C5CC),
                            fontSize: 10.0,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.message,
                              color: Color(0xFFC6C5CC),
                              size: 12.0,
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Text(
                              '3',
                              style: TextStyle(
                                color: Color(0xFFC6C5CC),
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Text(
                      'Show Details',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Color(0xFFC6C5CC),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LockedTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFDFE2ED),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0,),
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Day One',
                style: TextStyle(
                  color: Color(0xFF333333).withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'Feb. 4',
                style: TextStyle(
                  color: Color(0xFF333333).withOpacity(0.3),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

