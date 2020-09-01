import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class CommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 6.0),
      margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0, right: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFF27A6B6),
        borderRadius: BorderRadius.circular(4.0),
      ),
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
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    shape: BoxShape.circle,
                  ),
                  child: Image(
                    width: 20.0,
                    image: AssetImage('images/avatars/spiderman.png'),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stephen Colbert',
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '(Admin)',
                          style: TextStyle(
                            color: Color(0xFF27A6B6),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      'May 01, 2019',
                      style: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.6),
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  '5 hours ago',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.6),
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            RichText(
              text: TextSpan(
                text: 'Hey Spiderman I thought your comment was really interesting. It got me thinking that I would like to ask you one more question:',
                style: TextStyle(color: TEXT_COLOR, fontSize: 12.0, ),
                children: [
                  TextSpan(
                    text: '\n\nWhat is your favorite type of phone?',
                    style: TextStyle(
                      color: TEXT_COLOR,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    )
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
