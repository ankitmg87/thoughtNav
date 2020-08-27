import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_flat_button.dart';

import 'full_screen_new_widgets/custom_information_container.dart';

const _SELECTED_AVATAR_BORDER_COLOR = Color(0xFF00CC66);
const _SELECTED_AVATAR_BACKGROUND_COLOR = Color(0xFFB6ECC7);

class SelectAvatarScreen extends StatefulWidget {
  @override
  _SelectAvatarScreenState createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen> {
  PageController _pageController;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Step 1 of 3',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600.0,
          ),
          child: ListView(
            children: [
              CustomInformationContainer(
                title: 'Select your Display Profile',
                subtitle1:
                    'Your display profile contains the avatar and username you will be using during the study.',
                subtitle2:
                    'You cannot change your selection after your account has been created.',
              ),
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey[300],
                    ),
                  ),
                  child: Center(
                    child: CarouselSlider(
                      items: [
                        _Page1(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth),
                        _Page2(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth),
                        _Page3(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth),
                      ],
                      options: CarouselOptions(
                        aspectRatio: 1.0,
                        viewportFraction: 1.0,
                        enlargeCenterPage: true,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              CustomFlatButton(
                label: 'Continue',
                routeName: CONFIRM_DISPLAY_PROFILE_SCREEN,
              ),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Page1 extends StatelessWidget {
  const _Page1({
    Key key,
    @required this.screenHeight,
    @required this.screenWidth,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
        ),
        children: [
          AvatarContainer(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            imagePath: 'images/avatars/batman.png',
          ),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/queen.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/lego.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/wolverine.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/mummy.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/mr_t.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/spiderman.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/he_man.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/blue.png'),
        ],
      ),
    );
  }
}

class _Page2 extends StatelessWidget {
  const _Page2({
    Key key,
    @required this.screenHeight,
    @required this.screenWidth,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
        ),
        children: [
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/blue_clear.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/11.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/12.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/13.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/14.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/15.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/16.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/17.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/18.png'),
        ],
      ),
    );
  }
}

class _Page3 extends StatelessWidget {
  const _Page3({
    Key key,
    @required this.screenHeight,
    @required this.screenWidth,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
        ),
        children: [
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/19.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/20.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/21.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/22.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/23.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/24.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/25.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/26.png'),
          AvatarContainer(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              imagePath: 'images/avatars/27.png'),
        ],
      ),
    );
  }
}

class AvatarContainer extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String imagePath;

  const AvatarContainer(
      {Key key,
      @required this.screenWidth,
      @required this.screenHeight,
      @required this.imagePath})
      : super(key: key);

  @override
  _AvatarContainerState createState() => _AvatarContainerState();
}

class _AvatarContainerState extends State<AvatarContainer> {
  Color _currentBorderColor;
  Color _currentBackgroundColor;

  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _currentBorderColor = Colors.white;
    _currentBackgroundColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_tapped) {
          _currentBorderColor = Colors.white;
          _currentBackgroundColor = Colors.white;
          _tapped = false;
        } else if (!_tapped) {
          _currentBackgroundColor = _SELECTED_AVATAR_BACKGROUND_COLOR;
          _currentBorderColor = _SELECTED_AVATAR_BORDER_COLOR;
          _tapped = true;
        }
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _currentBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: _currentBorderColor, width: 5.0),
        ),
        child: Center(
          child: Image.asset(
            widget.imagePath,
            width: 200.0,
          ),
        ),
      ),
    );
  }
}
