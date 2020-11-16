import 'package:flutter/material.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

class LockedTaskWidget extends StatelessWidget {

  final Topic topic;

  const LockedTaskWidget({Key key, @required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFDFE2ED),
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      ),
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic.topicName,
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
                topic.topicDate.toDate().toString(),
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