import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

import 'custom_avatar_radio_widget.dart';
import 'custom_information_container.dart';

class OnboardingPage1 extends StatefulWidget {
  final Participant participant;
  final ParticipantFirestoreService participantFirestoreService;

  const OnboardingPage1({
    Key key,
    this.participant,
    this.participantFirestoreService,
  }) : super(key: key);

  @override
  _OnboardingPage1State createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1> {
  List<RadioModel> _avatarAndDisplayNameRadioModelList = [];

  List<AvatarAndDisplayName> _avatarAndDisplayNameList = [];

  Future<void> _futureAvatarsAndDisplayNames;

  Future<void> _getAvatarsAndDisplayNames() async {
    _avatarAndDisplayNameRadioModelList = [];

    var getStorage = GetStorage();

    var studyUID = getStorage.read('studyUID');

    _avatarAndDisplayNameList = await widget.participantFirestoreService
        .getAvatarsAndDisplayNames(studyUID);

    _avatarAndDisplayNameList.forEach((avatarAndDisplayName) {
      _avatarAndDisplayNameRadioModelList.add(RadioModel(
          widget.participant.displayName == avatarAndDisplayName.displayName
              ? true
              : false,
          avatarAndDisplayName));
    });
  }

  @override
  void initState() {
    _futureAvatarsAndDisplayNames = _getAvatarsAndDisplayNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    if (screenSize.height > screenSize.width) {
      return ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20.0,
          ),
          CustomInformationContainer(
            title: 'Select Your Display Profile',
            subtitle1:
            'Your display profile contains the avatar and username you will be using during the study.',
            subtitle2:
            'You cannot change your selection after your account has been created.',
          ),
          CustomAvatarRadioWidget(
            avatarFutureBuilder: FutureBuilder(
              future: _futureAvatarsAndDisplayNames,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text('Something went wrong'),
                    );
                    break;
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: Text('Loading Avatars...'),
                    );
                    break;
                  case ConnectionState.done:
                    return GridView.builder(
                      itemCount: _avatarAndDisplayNameRadioModelList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              _avatarAndDisplayNameRadioModelList.forEach(
                                      (radioModel) =>
                                  radioModel.isSelected = false);
                              _avatarAndDisplayNameRadioModelList[index]
                                  .isSelected = true;
                              widget.participant.profilePhotoURL =
                                  _avatarAndDisplayNameRadioModelList[index]
                                      .avatarAndDisplayName
                                      .avatarURL;
                              widget.participant.displayName =
                                  _avatarAndDisplayNameRadioModelList[index]
                                      .avatarAndDisplayName
                                      .displayName;
                            });
                          },
                          child: RadioItem(
                              _avatarAndDisplayNameRadioModelList[index]),
                        );
                      },
                    );
                    break;
                  default:
                    return SizedBox();
                }
              },
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SCROLL TO VIEW MORE AVATARS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  size: 16.0,
                  color: PROJECT_GREEN,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomInformationContainer(
            title: 'Select Your Display Profile',
            subtitle1:
            'Your display profile contains the avatar and username you will be using during the study.',
            subtitle2:
            'You cannot change your selection after your account has been created.',
            width: 400.0,
          ),
          SizedBox(
            width: 40.0,
          ),
          Container(
            width: 2.0,
            color: Colors.grey[300],
            height: 300.0,
          ),
          SizedBox(
            width: 40.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAvatarRadioWidget(
                avatarFutureBuilder: FutureBuilder(
                  future: _futureAvatarsAndDisplayNames,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: Text('Something went wrong'),
                        );
                        break;
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Center(
                          child: Text('Loading Avatars...'),
                        );
                        break;
                      case ConnectionState.done:
                        return GridView.builder(
                          itemCount: _avatarAndDisplayNameRadioModelList.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _avatarAndDisplayNameRadioModelList.forEach(
                                          (radioModel) =>
                                      radioModel.isSelected = false);
                                  _avatarAndDisplayNameRadioModelList[index]
                                      .isSelected = true;
                                  widget.participant.profilePhotoURL =
                                      _avatarAndDisplayNameRadioModelList[index]
                                          .avatarAndDisplayName
                                          .avatarURL;
                                  widget.participant.displayName =
                                      _avatarAndDisplayNameRadioModelList[index]
                                          .avatarAndDisplayName
                                          .displayName;
                                });
                              },
                              child: RadioItem(
                                  _avatarAndDisplayNameRadioModelList[index]),
                            );
                          },
                        );
                        break;
                      default:
                        return SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SCROLL TO VIEW MORE AVATARS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 16.0,
                      color: PROJECT_GREEN,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}