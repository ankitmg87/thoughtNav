import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/screens/participant/open_study/dashboard/dashboard_widgets/end_drawer_expansion_tile.dart';
import 'package:thoughtnav/screens/researcher/models/topic.dart';

class DesktopStudyNavigator extends StatefulWidget {
  final List<Topic> topics;
  final String participantUID;

  const DesktopStudyNavigator({Key key, this.topics, this.participantUID})
      : super(key: key);

  @override
  _DesktopStudyNavigatorState createState() => _DesktopStudyNavigatorState();
}

class _DesktopStudyNavigatorState extends State<DesktopStudyNavigator> {
  final _scrollController = ScrollController();
  double _value = 50.0;
  double _initialWidth = 50.0;
  double _finalWidth = 300.0;
  bool _isExpanded = false;
  bool _showDrawer = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedContainer(
        curve: Curves.ease,
        height: double.maxFinite,
        width: _value,
        color: Colors.white,
        duration: Duration(milliseconds: 200),
        onEnd: () {
          setState(() {
            if (_isExpanded) {
              _showDrawer = true;
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: _showDrawer
                        ? Text(
                            'Study Navigator',
                            maxLines: 1,
                            style: TextStyle(
                              color: TEXT_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showDrawer ? Icons.close : Icons.menu,
                    color: PROJECT_GREEN,
                  ),
                  onPressed: () {
                    setState(() {
                      if (!_isExpanded) {
                        _value = _finalWidth;
                        _isExpanded = !_isExpanded;
                      } else {
                        _value = _initialWidth;
                        _isExpanded = !_isExpanded;
                        _showDrawer = false;
                      }
                    });
                  },
                ),
              ],
            ),
            _showDrawer
                ? Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      isAlwaysShown: true,
                      child: ListView(
                        controller: _scrollController,
                        children: List.generate(widget.topics.length, (index) {
                          if (index == 0 &&
                              widget.topics[index].topicDate
                                      .millisecondsSinceEpoch <=
                                  Timestamp.now().millisecondsSinceEpoch) {
                            return EndDrawerExpansionTile(
                              title: widget.topics[index].topicName,
                              questions: widget.topics[index].questions,
                              participantUID: widget.participantUID,
                              topicUID: widget.topics[index].topicUID,
                            );
                          } else {
                            if (widget
                                    .topics[index - 1].questions.last.isProbe &&
                                widget.topics[index].topicDate
                                        .millisecondsSinceEpoch <=
                                    Timestamp.now().millisecondsSinceEpoch) {
                              return EndDrawerExpansionTile(
                                title: widget.topics[index].topicName,
                                questions: widget.topics[index].questions,
                                participantUID: widget.participantUID,
                                topicUID: widget.topics[index].topicUID,
                              );
                            } else {
                              if (widget.topics[index - 1].questions.last
                                      .respondedBy
                                      .contains(widget.participantUID) &&
                                  widget.topics[index].topicDate
                                          .millisecondsSinceEpoch <=
                                      Timestamp.now().millisecondsSinceEpoch) {
                                return EndDrawerExpansionTile(
                                  title: widget.topics[index].topicName,
                                  questions: widget.topics[index].questions,
                                  participantUID: widget.participantUID,
                                  topicUID: widget.topics[index].topicUID,
                                );
                              } else {
                                return LockedTopicListTile();
                              }
                            }
                          }
                        }).toList(),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class LockedTopicListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Topic Locked',
          pageBuilder: (BuildContext studyNavigatorLockedTopicContext,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Center(
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'This topic is still locked',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      title: Text(
        'Topic Locked',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
