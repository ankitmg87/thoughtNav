import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat.yMd();
    var formatTime = DateFormat.jm();

    var date = formatDate.format(comment.commentTimestamp.toDate());
    var time = formatTime.format(comment.commentTimestamp.toDate());

    var timeNow = DateTime.now();
    var elapsedTimeFormat = DateFormat('HH:mm a');
    var difference = timeNow.difference(DateTime.fromMillisecondsSinceEpoch(
        comment.commentTimestamp.millisecondsSinceEpoch * 1000));

    var timeElapsed = '';

    if (difference.inSeconds <= 0 ||
        difference.inSeconds > 0 && difference.inMinutes == 0 ||
        difference.inMinutes > 0 && difference.inHours == 0 ||
        difference.inHours > 0 && difference.inDays == 0) {
      timeElapsed = elapsedTimeFormat.format(
          DateTime.fromMillisecondsSinceEpoch(
              comment.commentTimestamp.millisecondsSinceEpoch * 1000));
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      if (difference.inDays == 1) {
        timeElapsed = difference.inDays.toString() + ' DAY AGO';
      } else {
        timeElapsed = difference.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (difference.inDays == 7) {
        timeElapsed = (difference.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        timeElapsed = (difference.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return Container(
      padding: EdgeInsets.only(left: 6.0),
      margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0, right: 30.0),
      decoration: BoxDecoration(
          color: Color(0xFF27A6B6),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Color(0xFF27A6B6).withOpacity(0.05),
            width: 0.25,
          )),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4.0),
            bottomRight: Radius.circular(4.0),
          ),
        ),
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 10.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: comment.avatarURL,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        shape: BoxShape.circle,
                      ),
                      child: Image(
                        width: 20.0,
                        image: imageProvider,
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.alias,
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      '$date at $time',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.8),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              comment.commentStatement,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
