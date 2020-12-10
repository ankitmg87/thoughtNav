import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/models/avatar_and_display_name.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

class CustomAvatarRadioWidget extends StatefulWidget {
  final Participant participant;
  final FutureBuilder avatarFutureBuilder;

  const CustomAvatarRadioWidget({
    Key key,
    this.participant,
 this.avatarFutureBuilder,
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
        child: widget.avatarFutureBuilder,
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            imageUrl: _item.avatarAndDisplayName.avatarURL,
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 50.0,
                height: 50.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _item.isSelected ? PROJECT_LIGHT_GREEN : Colors.white,
                  border: Border.all(
                    width: 2.0,
                    color: _item.isSelected ? PROJECT_GREEN : Colors.white,
                  ),
                ),
                child: Image(
                  image: imageProvider,
                ),
              );
            },
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            _item.avatarAndDisplayName.displayName,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 10.0,
              fontWeight:
                  _item.isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final AvatarAndDisplayName avatarAndDisplayName;

  RadioModel(this.isSelected, this.avatarAndDisplayName);
}
