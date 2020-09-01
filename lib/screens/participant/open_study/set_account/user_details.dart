import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: TEXT_COLOR,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Info',
          style: TextStyle(
            color: TEXT_COLOR,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
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
          Container(
            width: double.infinity,
            height: 1.0,
            color: TEXT_COLOR.withOpacity(0.2),
            margin: EdgeInsets.only(bottom: 20.0),
          ),
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Profile',
                  style: TextStyle(
                    color: TEXT_COLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0
                  ),
                ),
                SizedBox(height: 10.0,),
                _DetailsRow(
                  label: 'Real Name',
                  value: 'Sarah Baker',
                ),
                _DetailsRow(
                  label: 'Display Name',
                  value: '@batman',
                ),
                _DetailsRow(
                  label: 'Unique ID',
                  value: '#0816',
                ),
                _DetailsRow(
                  label: 'Group',
                  value: 'Group 2 - PWC Users',
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: TEXT_COLOR.withOpacity(0.2),
            margin: EdgeInsets.only(bottom: 20.0),
          ),
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Info',
                  style: TextStyle(
                      color: TEXT_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0
                  ),
                ),
                SizedBox(height: 10.0,),
                _DetailsRow(
                  label: 'Email',
                  value: 'sarah@gmail.com',
                ),
                _DetailsRow(
                  label: 'Reward Email',
                  value: 'sarahamazon@gmail.com',
                ),
                _DetailsRow(
                  label: 'Password',
                  value: 'masterPassword',
                ),
                _DetailsRow(
                  label: 'Date of Birth',
                  value: 'January 15, 1975',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {

  final String label;
  final String value;

  const _DetailsRow({
    Key key, this.label, this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              label,
              style: TextStyle(
                color: TEXT_COLOR.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
