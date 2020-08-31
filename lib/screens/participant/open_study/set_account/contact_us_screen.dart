import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/string_constants.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildPhoneAppBar(),
      body: buildPhoneBody(screenSize),
    );
  }

  Widget buildPhoneBody(Size screenSize) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: screenSize.height,
            width: screenSize.width,
          ),
          Container(
            width: double.infinity,
            height: screenSize.height * 0.65,
            color: PROJECT_GREEN,
          ),
          Positioned(
            top: screenSize.height * 0.05,
            child: Container(
              width: screenSize.width,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'We\'re here to help',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 222.0,
                      height: 116.0,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20.0,
                            bottom: 15.0,
                            child: Image(
                              width: 82.0,
                              height: 81.0,
                              image: AssetImage(
                                'images/set_account_icons/blue_shirt_man.png',
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            left: 50.0,
                            bottom: 35.0,
                            child: Image(
                              width: 82.0,
                              height: 81.0,
                              image: AssetImage(
                                'images/set_account_icons/red_jacket_woman.png',
                              ),
                            ),
                          ),
                          Positioned(
                            top: 35.0,
                            left: 82.0,
                            bottom: 0.0,
                            child: Image(
                              width: 82.0,
                              height: 81.0,
                              image: AssetImage(
                                'images/set_account_icons/white_shirt_woman.png',
                              ),
                            ),
                          ),
                          Positioned(
                            top: 14.0,
                            bottom: 21.0,
                            right: 0.0,
                            child: Image(
                              width: 82.0,
                              height: 81.0,
                              image: AssetImage(
                                'images/set_account_icons/light_blue_jacket_man.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.mail,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          SizedBox(width: 5.0,),
                          Text(
                            'Email\nsupport@thoughtnav.com',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.4,
            right: 20.0,
            left: 20.0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: 10.0,
              ),
              width: screenSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.5),
                        fontSize: 14.0,
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.5),
                        fontSize: 14.0,
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      hintStyle: TextStyle(
                        color: TEXT_COLOR.withOpacity(0.5),
                        fontSize: 14.0,
                      ),
                      border: InputBorder.none,
                    ),
                    minLines: 5,
                    maxLines: 5,
                    cursorColor: Colors.black,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PROJECT_GREEN,
                        ),
                        child: Image(
                          width: 20.0,
                          image: AssetImage(
                              'images/set_account_icons/send_message_icon.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildPhoneAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {},
        icon: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PROJECT_LIGHT_GREEN,
          ),
          child: Image(
            width: 24.0,
            image: AssetImage(
              'images/avatars/batman.png',
            ),
          ),
        ),
      ),
      title: Text(
        APP_NAME,
        style: TextStyle(
          color: TEXT_COLOR,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: PROJECT_GREEN,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
