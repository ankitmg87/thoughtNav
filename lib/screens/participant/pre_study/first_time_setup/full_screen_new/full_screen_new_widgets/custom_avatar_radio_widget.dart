// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';

class CustomAvatarRadioWidget extends StatefulWidget {
  final Participant participant;
  final StreamBuilder avatarStreamBuilder;

  const CustomAvatarRadioWidget({
    Key key,
    this.participant,
    this.avatarStreamBuilder,
  }) : super(key: key);

  @override
  _CustomAvatarRadioWidgetState createState() =>
      _CustomAvatarRadioWidgetState();
}

class _CustomAvatarRadioWidgetState extends State<CustomAvatarRadioWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 300.0,
          maxHeight: 300.0,
        ),
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(
            color: PROJECT_NAVY_BLUE.withOpacity(0.1),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: widget.avatarStreamBuilder,
      ),
    );
  }
}

class AvatarRadioItem extends StatelessWidget {
  final AvatarRadioModel _avatarRadioModel;

  AvatarRadioItem(this._avatarRadioModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: _avatarRadioModel.avatarAndDisplayName.avatarURL,
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 50.0,
                height: 50.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _avatarRadioModel.isSelected
                      ? PROJECT_LIGHT_GREEN
                      : Colors.white,
                  border: Border.all(
                    width: 2.0,
                    color: _avatarRadioModel.isSelected
                        ? PROJECT_GREEN
                        : Colors.white,
                  ),
                ),
                child: Image(
                  image: imageProvider,
                ),
              );
            },
            errorWidget: (_c, _s, _d) {
              return Container(
                width: 50.0,
                height: 50.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _avatarRadioModel.isSelected
                      ? PROJECT_LIGHT_GREEN
                      : Colors.white,
                  border: Border.all(
                    width: 2.0,
                    color: _avatarRadioModel.isSelected
                        ? PROJECT_GREEN
                        : Colors.white,
                  ),
                ),
                child: Image(
                  image: AssetImage(
                    'images/researcher_images/researcher_dashboard/participant_icon.png',
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            _avatarRadioModel.avatarAndDisplayName.displayName,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 10.0,
              fontWeight:
                  _avatarRadioModel.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarRadioModel {
  bool isSelected;
  final AvatarAndDisplayName avatarAndDisplayName;

  AvatarRadioModel(this.isSelected, this.avatarAndDisplayName);
}
