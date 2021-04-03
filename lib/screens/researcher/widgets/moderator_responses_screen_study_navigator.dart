import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class ModeratorResponsesScreenStudyNavigator extends StatefulWidget {
  final int itemCount;
  final Function(BuildContext context, int index) itemBuilder;

  const ModeratorResponsesScreenStudyNavigator({
    Key key,
    this.itemCount,
    this.itemBuilder,
  }) : super(key: key);

  @override
  _ModeratorResponsesScreenStudyNavigatorState createState() =>
      _ModeratorResponsesScreenStudyNavigatorState();
}

class _ModeratorResponsesScreenStudyNavigatorState
    extends State<ModeratorResponsesScreenStudyNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      thickness: 10.0,
      child: ListView.builder(
        padding: EdgeInsets.only(right: 20.0,),
        itemCount: widget.itemCount,
        itemBuilder: widget.itemBuilder,
      ),
    );
  }
}
