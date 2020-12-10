import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/end_drawer_expansion_tile_child.dart';
import 'package:thoughtnav/screens/researcher/models/question.dart';

class EndDrawerExpansionTile extends StatefulWidget {
  const EndDrawerExpansionTile({
    Key key,
    this.title,
    this.questions,
    this.onChildTapped,
    this.participantUID,
  }) : super(key: key);

  final String title;
  final List<Question> questions;
  final Function onChildTapped;
  final String participantUID;

  @override
  _EndDrawerExpansionTileState createState() => _EndDrawerExpansionTileState();
}

class _EndDrawerExpansionTileState extends State<EndDrawerExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: _isExpanded ? 0.0 : 6.0),
      child: Column(
        children: [
          ExpansionTile(
            tilePadding:
                EdgeInsets.only(right: 16.0, left: _isExpanded ? 16.0 : 10.0),
            title: Text(
              widget.title,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 14.0,
              ),
            ),
            trailing: _isExpanded
                ? Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  )
                : Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  ),
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
            },
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return EndDrawerExpansionTileChild(
                    label:
                        '${widget.questions[index].questionNumber} ${widget.questions[index].questionTitle}',
                    onTap: widget.onChildTapped,
                    question: widget.questions[index],
                    participantUID: widget.participantUID,
                  );
                },
              ),
            ],
          ),
          Container(
            height: 0.5,
            width: double.infinity,
            color: Color(0xFF888888).withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
