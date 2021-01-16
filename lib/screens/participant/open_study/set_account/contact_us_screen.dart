import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/constants/routes/routes.dart';
import 'package:thoughtnav/constants/string_constants.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _participantFirestoreService = ParticipantFirestoreService();

  String _studyName = '';

  Participant _participant;

  Future<void> _futureParticipant;

  Future<void> _getFutureParticipant(
      String studyUID, String participantUID) async {
    _participant = await _participantFirestoreService.getParticipant(
        studyUID, participantUID);
  }

  @override
  void initState() {
    var getStorage = GetStorage();

    _studyName = getStorage.read('studyName');

    var studyUID = getStorage.read('studyUID');
    var participantUID = getStorage.read('participantUID');

    _futureParticipant = _getFutureParticipant(studyUID, participantUID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (screenSize.height > screenSize.width) {
      return Scaffold(
        appBar: buildPhoneAppBar(),
        body: buildPhoneBody(screenSize),
      );
    } else {
      return _buildDesktopScreen(screenSize);
    }
  }

  FutureBuilder<void> _buildDesktopScreen(Size screenSize) {
    return FutureBuilder<void>(
      future: _futureParticipant,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Material(
              child: Center(
                child: Text(
                  'Something went wrong',
                ),
              ),
            );
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Material(
              child: Center(
                child: Text(
                  'Please wait',
                ),
              ),
            );
            break;
          case ConnectionState.done:
            return Scaffold(
              appBar: _buildDesktopAppBar(),
              body: Container(
                color: PROJECT_GREEN,
                width: screenSize.width,
                height: screenSize.height,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'We\'re here to Help',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                width: screenSize.width * 0.5,
                                child: Center(
                                  child: Container(
                                    width: 400.0,
                                    height: 200.0,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 20.0,
                                          bottom: 15.0,
                                          child: Image(
                                            width: 150.0,
                                            height: 150.0,
                                            image: AssetImage(
                                              'images/set_account_icons/blue_shirt_man.png',
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0.0,
                                          left: 79.0,
                                          bottom: 80.0,
                                          child: Image(
                                            width: 150.0,
                                            height: 150.0,
                                            image: AssetImage(
                                              'images/set_account_icons/red_jacket_woman.png',
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 35.0,
                                          left: 137.0,
                                          bottom: 0.0,
                                          child: Image(
                                            width: 150.0,
                                            height: 150.0,
                                            image: AssetImage(
                                              'images/set_account_icons/white_shirt_woman.png',
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 6.0,
                                          child: Image(
                                            width: 150.0,
                                            height: 150.0,
                                            image: AssetImage(
                                              'images/set_account_icons/light_blue_jacket_man.png',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: screenSize.width * 0.5,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Email\nsupport@thoughtnav.com',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Card(
                                        elevation: 4.0,
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                initialValue:
                                                    '${_participant.userFirstName} ${_participant.userLastName}',
                                                enabled: false,
                                                style: TextStyle(
                                                  color: TEXT_COLOR
                                                      .withOpacity(0.5),
                                                  fontSize: 14.0,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: TEXT_COLOR
                                                        .withOpacity(0.5),
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                cursorColor: Colors.black,
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              TextFormField(
                                                initialValue:
                                                    _participant.email,
                                                enabled: false,
                                                style: TextStyle(
                                                  color: TEXT_COLOR
                                                      .withOpacity(0.5),
                                                  fontSize: 14.0,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'Email',
                                                  hintStyle: TextStyle(
                                                    color: TEXT_COLOR
                                                        .withOpacity(0.5),
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                cursorColor: Colors.black,
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              TextFormField(
                                                style: TextStyle(
                                                  color: TEXT_COLOR
                                                      .withOpacity(0.5),
                                                  fontSize: 14.0,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Type your message here',
                                                  hintStyle: TextStyle(
                                                    color: TEXT_COLOR
                                                        .withOpacity(0.5),
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
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: FlatButton(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image(
                                                          width: 10.0,
                                                          image: AssetImage(
                                                            'images/set_account_icons/send_message_icon.png',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                          'SEND',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .popAndPushNamed(
                                                            PARTICIPANT_DASHBOARD_SCREEN);
                                                  },
                                                  color: PROJECT_GREEN,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            break;
          default:
            return const SizedBox();
        }
      },
    );
  }

  AppBar _buildDesktopAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Text(
            APP_NAME,
            style: TextStyle(
              color: TEXT_COLOR,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      leadingWidth: 120.0,
      title: Text(
        _studyName,
        style: TextStyle(
          color: TEXT_COLOR,
        ),
      ),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () {
            Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Go To Dashboard',
                  style: TextStyle(
                    color: TEXT_COLOR.withOpacity(0.7),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 14.0,
                color: TEXT_COLOR.withOpacity(0.8),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPhoneBody(Size screenSize) {
    return FutureBuilder(
      future: _futureParticipant,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: Text(
                'Loading...'
              ),
            );
            break;
          case ConnectionState.done:
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
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'Email\nsupport@thoughtnav.com',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
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
                          TextFormField(
                            initialValue: '${_participant.userFirstName} ${_participant.userLastName}',
                            enabled: false,
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
                          TextFormField(
                            initialValue: _participant.email,
                            enabled: false,
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
                          TextFormField(
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
            break;
          default:
            return Center(
              child: Text(
                  'Loading...'
              ),
            );
        }
      },
    );
  }

  AppBar buildPhoneAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(icon: Icon(
        Icons.keyboard_arrow_left,
        color: Colors.black,
      ), onPressed: () {
        Navigator.of(context).popAndPushNamed(PARTICIPANT_DASHBOARD_SCREEN);
      },),
      backgroundColor: Colors.white,
      title: Text(
        'Contact Us',
        style: TextStyle(
          color: TEXT_COLOR,
        ),
      ),
      centerTitle: true,
    );
  }
}
