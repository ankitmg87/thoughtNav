import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/misc_constants.dart';

class CommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        elevation: 2.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 10.0,
                color: Color(0xFF27A6B6),
              ),
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      'images/avatars/spiderman.png',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Spiderman - ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Dylan Ryder',
                                    style: TextStyle(
                                      color: PROJECT_GREEN,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              '11/25/2020 at 12:18 pm',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '3 minutes ago',
                          style: TextStyle(
                            color: PROJECT_GREEN,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      TEMPORARY_QUESTION,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.reply,
                        color: PROJECT_GREEN,
                        size: 20.0,
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
