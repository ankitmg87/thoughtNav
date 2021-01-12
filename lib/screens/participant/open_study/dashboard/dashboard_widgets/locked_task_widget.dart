import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

class LockedTaskWidget extends StatelessWidget {
  final Topic topic;

  const LockedTaskWidget({Key key, @required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    var date = formatDate.format(topic.topicDate.toDate());
    var time = formatTime.format(topic.topicDate.toDate());

    return InkWell(
      onTap: () {
        showGeneralDialog(
          barrierDismissible: true,
          barrierLabel: 'Locked Question Dialog',
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Center(
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    topic.topicDate.millisecondsSinceEpoch >
                            Timestamp.now().millisecondsSinceEpoch
                        ? 'This topic will be unlocked after $date at $time'
                        : 'All questions in previous topics must be answered to unlock this topic',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          },
          context: context,
        );
      },
      child: Container(
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
                  'Begins $date at $time',
                  style: TextStyle(
                    color: Color(0xFF333333).withOpacity(0.3),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
