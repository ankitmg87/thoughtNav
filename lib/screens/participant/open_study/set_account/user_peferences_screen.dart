import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class UserPreferencesScreen extends StatefulWidget {
  @override
  _UserPreferencesScreenState createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: TEXT_COLOR,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          Align(
            child: Container(
              width: screenSize.height > screenSize.width ? double.maxFinite : screenSize.width * 0.5,
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 20.0,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PROJECT_LIGHT_GREEN,
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Image(
                        image: AssetImage(
                          'images/avatars/batman.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ralph Joe',
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        '@batman-0816',
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            child: Container(
              color: Colors.white,
              width: screenSize.height > screenSize.width ? double.maxFinite : screenSize.width * 0.5,
              padding: EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 30.0,
                bottom: 50.0,
              ),
              child: Column(
                children: [
                  _CustomRow(
                    label: 'Display Name',
                    value: '@batman-0816',
                  ),
                  _CustomRow(
                    label: 'Email Address',
                    value: 'sarah@gmail.com',
                  ),
                  _CustomRow(
                    label: 'Group',
                    value: 'Group 2 - PWC Users',
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  DottedBorder(
                    dashPattern: [10, 1],
                    strokeWidth: 0.08,
                    padding: EdgeInsets.all(0.0),
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  _CustomRow(
                    label: 'Full Name',
                    value: 'Sarah Baker',
                  ),
                  _CustomRow(
                    label: 'Date of Birth',
                    value: 'January 31, 1975',
                  ),
                ],
              ),
            ),
          ),
          Align(
            child: Container(
              width: screenSize.height > screenSize.width ? double.maxFinite : screenSize.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0,),
              child: Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: PROJECT_GREEN,
                      child: Text(
                        'Edit Info',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      onPressed: (){},
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
}

class _CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const _CustomRow({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(12.0),
            child: Text(
              label,
              style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
