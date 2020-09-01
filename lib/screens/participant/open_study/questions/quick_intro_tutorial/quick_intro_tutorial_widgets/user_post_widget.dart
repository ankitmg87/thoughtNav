import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class UserPostWidget extends StatelessWidget {
  final String avatar;
  final String alias;
  final String date;
  final String time;
  final bool hasImage;
  final String imageURL;
  final String post;
  final String likes;
  final String comments;
  final Size screenSize;

  const UserPostWidget({
    Key key,
    this.avatar,
    this.alias,
    this.date,
    this.time,
    @required this.hasImage,
    this.imageURL,
    this.post,
    this.likes,
    this.comments,
    @required this.screenSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      shape: BoxShape.circle,
                    ),
                    child: Image(
                      width: 20.0,
                      image: AssetImage(
                        'images/avatars/spiderman.png',
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
                        'Spiderman',
                        style: TextStyle(
                          color: TEXT_COLOR.withOpacity(0.6),
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
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
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '5 hours ago',
                    style: TextStyle(
                      color: TEXT_COLOR.withOpacity(0.6),
                      fontSize: 10.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'They would say I\'m the go to person for tech. I buy nearly every device that comes to the market, because I run my own YouTube tech channel.  I\'m up on all the latest technology, and I\'m online 24/7. Currently using the Nexus 6P as my daily driver.',
            style: TextStyle(
              color: TEXT_COLOR,
              fontSize: 12.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          hasImage
              ? Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage('images/placeholder_image.jpg'),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          hasImage
              ? SizedBox(
                  height: 20.0,
                )
              : SizedBox(),
          Row(
            children: [
              Image(
                image: AssetImage('images/questions_icons/clap_icon.png'),
                width: 30.0,
                color: TEXT_COLOR.withOpacity(0.8),
              ),
              Text('1', style: TextStyle(color: TEXT_COLOR.withOpacity(0.8),fontSize: 12.0),),
              SizedBox(width: 16.0,),
              Image(
                image: AssetImage('images/questions_icons/comment_icon.png'),
                width: 15.0,
                color: TEXT_COLOR.withOpacity(0.8),
              ),
              SizedBox(width: 6.0,),
              Text('1', style: TextStyle(color: TEXT_COLOR.withOpacity(0.8),fontSize: 12.0),),
            ],
          ),
        ],
      ),
    );
  }
}
