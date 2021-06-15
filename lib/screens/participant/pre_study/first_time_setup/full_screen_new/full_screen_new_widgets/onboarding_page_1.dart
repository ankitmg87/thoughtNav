// Copyright © 2021, Aperio Insights. Version 1.0.0
// All rights reserved.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';
import 'package:thoughtnav/screens/participant/pre_study/first_time_setup/full_screen_new/full_screen_new_widgets/custom_avatar_radio_widget.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

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
  List<AvatarRadioModel> _avatarAndDisplayNameRadioModelList = [];

  ScrollController _avatarsScrollController;

  Future<void> _futureAvatarsAndDisplayNames;

  String studyUID;

  String _profilePhotoURL;
  String _displayName;
  String _previousDisplayName;

  double _scrollPosition = 0.0;

  AvatarAndDisplayName _currentAvatarAndDisplayName;
  AvatarAndDisplayName _previousAvatarAndDisplayName;

  String _currentAvatarAndDisplayNameID;
  String _previousAvatarAndDisplayNameID;

  void _unAwaited(Future<void> future) {}

  Stream<QuerySnapshot> _avatarAndDisplayNameStream;

  Stream<QuerySnapshot> _getAvatarAndDisplayNameStream() {
    var getStorage = GetStorage();

    studyUID = getStorage.read('studyUID');

    return widget.participantFirestoreService
        .getAvatarsAndDisplayNames(studyUID);
  }

  @override
  void initState() {
    _avatarAndDisplayNameStream = _getAvatarAndDisplayNameStream();
    super.initState();

    _avatarsScrollController = ScrollController();
    _avatarsScrollController.addListener(() {});
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
            avatarStreamBuilder: StreamBuilder<QuerySnapshot>(
              stream: _avatarAndDisplayNameStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return SizedBox();
                    break;
                  case ConnectionState.waiting:
                  case ConnectionState.active:

                  if (snapshot.hasData) {
                    var documents;

                    documents = snapshot.data.docs;

                    _avatarAndDisplayNameRadioModelList.clear();

                    if (widget.participant.displayName != null) {
                      _displayName = widget.participant.displayName;
                    }

                    documents.forEach((document) {
                      if (document['selected'] == false ||
                          document['displayName'] == _displayName) {
                        _avatarAndDisplayNameRadioModelList.add(
                          AvatarRadioModel(
                            _displayName == null
                                ? false
                                : _displayName == document['displayName']
                                ? true
                                : false,
                            AvatarAndDisplayName(
                              id: document['id'],
                              avatarURL: document['avatarURL'],
                              displayName: document['displayName'],
                              selected: document['selected'],
                            ),
                          ),
                        );
                      }
                    });

                    return GridView.builder(
                      controller: _avatarsScrollController,
                      itemCount:
                      _avatarAndDisplayNameRadioModelList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_displayName == null) {
                              setState(() {
                                _avatarAndDisplayNameRadioModelList
                                    .forEach((avatarRadioModel) {
                                  avatarRadioModel.isSelected = false;
                                });

                                _avatarAndDisplayNameRadioModelList[index]
                                    .isSelected = true;

                                _displayName =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .avatarAndDisplayName
                                        .displayName;
                                _profilePhotoURL =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .avatarAndDisplayName
                                        .avatarURL;
                                _avatarAndDisplayNameRadioModelList[index]
                                    .avatarAndDisplayName
                                    .selected =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .isSelected;

                                widget.participant.displayName =
                                    _displayName;
                                widget.participant.profilePhotoURL =
                                    _profilePhotoURL;

                                _currentAvatarAndDisplayNameID =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .avatarAndDisplayName
                                        .id;

                                _unAwaited(widget
                                    .participantFirestoreService
                                    .updateAvatarAndDisplayNameStatus(
                                    studyUID,
                                    _currentAvatarAndDisplayNameID,
                                    true));
                              });
                            } else {
                              _previousAvatarAndDisplayNameID =
                                  _currentAvatarAndDisplayNameID;

                              _unAwaited(widget
                                  .participantFirestoreService
                                  .updateAvatarAndDisplayNameStatus(
                                  studyUID,
                                  _previousAvatarAndDisplayNameID,
                                  false));

                              setState(() {
                                _avatarAndDisplayNameRadioModelList
                                    .forEach((avatarRadioModel) {
                                  avatarRadioModel.isSelected = false;
                                });

                                _avatarAndDisplayNameRadioModelList[index]
                                    .isSelected = true;

                                _displayName =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .avatarAndDisplayName
                                        .displayName;
                                _profilePhotoURL =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .avatarAndDisplayName
                                        .avatarURL;
                                _avatarAndDisplayNameRadioModelList[index]
                                    .avatarAndDisplayName
                                    .selected =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .isSelected;

                                widget.participant.displayName =
                                    _displayName;
                                widget.participant.profilePhotoURL =
                                    _profilePhotoURL;

                                _currentAvatarAndDisplayNameID =
                                    _avatarAndDisplayNameRadioModelList[
                                    index]
                                        .avatarAndDisplayName
                                        .id;
                              });

                              _unAwaited(widget
                                  .participantFirestoreService
                                  .updateAvatarAndDisplayNameStatus(
                                  studyUID,
                                  _currentAvatarAndDisplayNameID,
                                  true));
                            }
                          },
                          child: AvatarRadioItem(
                            _avatarAndDisplayNameRadioModelList[index],
                          ),
                        );
                      },
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                    break;
                  case ConnectionState.done:
                    return SizedBox();
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
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (_scrollPosition >=
                    _avatarsScrollController.position.maxScrollExtent) {
                  _scrollPosition = 0.0;
                  _avatarsScrollController.animateTo(
                    _scrollPosition,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                  );
                  return;
                } else if (_scrollPosition == 0) {
                  _scrollPosition = 120.0;
                  _avatarsScrollController.animateTo(
                    _scrollPosition,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                  );
                  return;
                } else {
                  _scrollPosition += 120.0;

                  _avatarsScrollController.animateTo(
                    _scrollPosition,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                  );
                }
              },
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
                    size: 30.0,
                    color: PROJECT_GREEN,
                  ),
                ],
              ),
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
                avatarStreamBuilder: StreamBuilder<QuerySnapshot>(
                  stream: _avatarAndDisplayNameStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return SizedBox();
                        break;
                      case ConnectionState.waiting:
                        return SizedBox();
                        break;
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          var documents;

                          documents = snapshot.data.docs;

                          _avatarAndDisplayNameRadioModelList.clear();

                          if (widget.participant.displayName != null) {
                            _displayName = widget.participant.displayName;
                          }

                          documents.forEach((document) {
                            if (document['selected'] == false ||
                                document['displayName'] == _displayName) {
                              _avatarAndDisplayNameRadioModelList.add(
                                AvatarRadioModel(
                                  _displayName == null
                                      ? false
                                      : _displayName == document['displayName']
                                          ? true
                                          : false,
                                  AvatarAndDisplayName(
                                    id: document['id'],
                                    avatarURL: document['avatarURL'],
                                    displayName: document['displayName'],
                                    selected: document['selected'],
                                  ),
                                ),
                              );
                            }
                          });

                          return GridView.builder(
                            controller: _avatarsScrollController,
                            itemCount:
                                _avatarAndDisplayNameRadioModelList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (_displayName == null) {
                                    setState(() {
                                      _avatarAndDisplayNameRadioModelList
                                          .forEach((avatarRadioModel) {
                                        avatarRadioModel.isSelected = false;
                                      });

                                      _avatarAndDisplayNameRadioModelList[index]
                                          .isSelected = true;

                                      _displayName =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .avatarAndDisplayName
                                              .displayName;
                                      _profilePhotoURL =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .avatarAndDisplayName
                                              .avatarURL;
                                      _avatarAndDisplayNameRadioModelList[index]
                                              .avatarAndDisplayName
                                              .selected =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .isSelected;

                                      widget.participant.displayName =
                                          _displayName;
                                      widget.participant.profilePhotoURL =
                                          _profilePhotoURL;

                                      _currentAvatarAndDisplayNameID =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .avatarAndDisplayName
                                              .id;

                                      _unAwaited(widget
                                          .participantFirestoreService
                                          .updateAvatarAndDisplayNameStatus(
                                              studyUID,
                                              _currentAvatarAndDisplayNameID,
                                              true));
                                    });
                                  } else {
                                    _previousAvatarAndDisplayNameID =
                                        _currentAvatarAndDisplayNameID;

                                    _unAwaited(widget
                                        .participantFirestoreService
                                        .updateAvatarAndDisplayNameStatus(
                                            studyUID,
                                            _previousAvatarAndDisplayNameID,
                                            false));

                                    setState(() {
                                      _avatarAndDisplayNameRadioModelList
                                          .forEach((avatarRadioModel) {
                                        avatarRadioModel.isSelected = false;
                                      });

                                      _avatarAndDisplayNameRadioModelList[index]
                                          .isSelected = true;

                                      _displayName =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .avatarAndDisplayName
                                              .displayName;
                                      _profilePhotoURL =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .avatarAndDisplayName
                                              .avatarURL;
                                      _avatarAndDisplayNameRadioModelList[index]
                                              .avatarAndDisplayName
                                              .selected =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .isSelected;

                                      widget.participant.displayName =
                                          _displayName;
                                      widget.participant.profilePhotoURL =
                                          _profilePhotoURL;

                                      _currentAvatarAndDisplayNameID =
                                          _avatarAndDisplayNameRadioModelList[
                                                  index]
                                              .avatarAndDisplayName
                                              .id;
                                    });

                                    _unAwaited(widget
                                        .participantFirestoreService
                                        .updateAvatarAndDisplayNameStatus(
                                            studyUID,
                                            _currentAvatarAndDisplayNameID,
                                            true));
                                  }
                                },
                                child: AvatarRadioItem(
                                  _avatarAndDisplayNameRadioModelList[index],
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                        break;
                      case ConnectionState.done:
                        return SizedBox();
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
                child: InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (_scrollPosition >=
                        _avatarsScrollController.position.maxScrollExtent) {
                      _scrollPosition = 0.0;
                      _avatarsScrollController.animateTo(
                        _scrollPosition,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn,
                      );
                      return;
                    } else if (_scrollPosition == 0) {
                      _scrollPosition = 120.0;
                      _avatarsScrollController.animateTo(
                        _scrollPosition,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn,
                      );
                      return;
                    } else {
                      _scrollPosition += 120.0;

                      _avatarsScrollController.animateTo(
                        _scrollPosition,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn,
                      );
                    }
                  },
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
                        size: 30.0,
                        color: PROJECT_GREEN,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
