import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/researcher/models/comment.dart';
import 'package:thoughtnav/services/participant_firestore_service.dart';

class CommentWidget extends StatefulWidget {
  final String participantUID;
  final String studyUID;
  final String topicUID;
  final String questionUID;
  final String responseUID;
  final Comment comment;
  final ParticipantFirestoreService participantFirestoreService;

  const CommentWidget(
      {Key key,
      this.comment,
      this.participantUID,
      this.participantFirestoreService,
      this.studyUID,
      this.topicUID,
      this.questionUID,
      this.responseUID})
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _editable = false;

  String _commentStatement;

  void _toggleEditable() {
    setState(() {
      _editable = !_editable;
    });
  }

  void _editComment() async {
    await widget.participantFirestoreService.updateComment(
        widget.studyUID,
        widget.topicUID,
        widget.questionUID,
        widget.responseUID,
        widget.comment);
  }

  @override
  Widget build(BuildContext context) {
    var formatDate = DateFormat(DateFormat.ABBR_MONTH_DAY);
    var formatTime = DateFormat.jm();

    var date = formatDate.format(widget.comment.commentTimestamp.toDate());
    var time = formatTime.format(widget.comment.commentTimestamp.toDate());

    _commentStatement = widget.comment.commentStatement;


    return Container(
      padding: EdgeInsets.only(left: 6.0),
      margin: EdgeInsets.only(left: 30.0, top: 5.0, bottom: 5.0, right: 30.0),
      decoration: BoxDecoration(
          color: Color(0xFF27A6B6),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Color(0xFF27A6B6).withOpacity(0.05),
            width: 0.25,
          )),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4.0),
            bottomRight: Radius.circular(4.0),
          ),
        ),
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 10.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.comment.avatarURL != null ?
                    CachedNetworkImage(
                      imageUrl: widget.comment.avatarURL,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.pink[100],
                            shape: BoxShape.circle,
                          ),
                          child: Image(
                            width: 20.0,
                            image: imageProvider,
                          ),
                        );
                      },
                    ) :  Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        shape: BoxShape.circle,
                      ),
                      child: Image(
                        width: 20.0,
                        image: AssetImage(
                            'images/researcher_images/researcher_dashboard/participant_icon.png'
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
                          widget.comment.displayName ?? 'Mike the Moderator',
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          '$date at $time',
                          style: TextStyle(
                            color: TEXT_COLOR.withOpacity(0.8),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                widget.comment.participantUID == widget.participantUID &&
                        !_editable
                    ? IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: TEXT_COLOR.withOpacity(0.6),
                          size: 16.0,
                        ),
                        onPressed: () {
                          _toggleEditable();
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            widget.comment.participantUID == widget.participantUID
                ? Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (commentStatement){
                            widget.comment.commentStatement = commentStatement;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          enabled: _editable,
                          initialValue: widget.comment.commentStatement,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      _editable
                          ? FlatButton(
                              onPressed: widget.comment.commentStatement.isNotEmpty ? () {
                                _toggleEditable();
                                _editComment();
                              } : null,
                              child: Text('POST'),
                            )
                          : SizedBox(),
                    ],
                  )
                : Row(
                  children: [
                    Expanded(
                      child: Text(
                          _commentStatement,
                          style: TextStyle(
                            color: TEXT_COLOR,
                            fontSize: 14.0,
                          ),
                        ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
