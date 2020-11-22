import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/group.dart';
import 'package:thoughtnav/screens/researcher/models/participant.dart';
import 'package:thoughtnav/services/firebase_firestore_service.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  final List<Group> groups;
  final FirebaseFirestoreService firebaseFirestoreService;

  const ParticipantTile({
    Key key,
    this.participant,
    this.groups,
    this.firebaseFirestoreService,
  }) : super(key: key);

  @override
  _ParticipantTileState createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  bool _selected;

  void _updateParticipant(Participant participant) async {}

  @override
  void initState() {
    _selected = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text(widget.participant.id),
          SizedBox(
            width: 40.0,
          ),
          Expanded(
            child: Text(widget.participant.email),
          ),
          SizedBox(
            width: 40.0,
          ),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(
                  10.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 0.5,
                  ),
                ),
                child: Text(
                  'Unassigned',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40.0,
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.ellipsis_vertical,
              size: 14.0,
              color: Colors.white,
            ),
            onPressed: null,
          ),
          SizedBox(
            width: 20.0,
          ),
        ],
      ),
    );
  }
}
