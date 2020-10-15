import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class DynamicGroupAndQuestionAdditionWidget extends StatefulWidget {
  final Widget child;
  final Widget separatorWidget;
  final String title;

  const DynamicGroupAndQuestionAdditionWidget({
    Key key,
    this.child,
    this.title,
    this.separatorWidget,
  }) : super(key: key);

  @override
  _DynamicGroupAndQuestionAdditionWidgetState createState() =>
      _DynamicGroupAndQuestionAdditionWidgetState();
}

class _DynamicGroupAndQuestionAdditionWidgetState
    extends State<DynamicGroupAndQuestionAdditionWidget> {
  int numberOfChildren = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    numberOfChildren > 1
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                numberOfChildren--;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.red[800],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.clear,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 5.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          numberOfChildren++;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: PROJECT_GREEN,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.add_circled,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 1.0,
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 16.0,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return widget.separatorWidget ?? SizedBox();
              },
              itemCount: numberOfChildren,
              itemBuilder: (BuildContext context, int index) {
                return widget.child;
              },
            ),
          ],
        ),
      ),
    );
  }
}
