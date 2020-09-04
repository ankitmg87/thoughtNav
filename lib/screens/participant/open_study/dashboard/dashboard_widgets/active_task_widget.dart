import 'package:flutter/material.dart';
import 'package:thoughtnav/constants/color_constants.dart';

class ActiveTaskWidget extends StatefulWidget {
  @override
  _ActiveTaskWidgetState createState() => _ActiveTaskWidgetState();
}

class _ActiveTaskWidgetState extends State<ActiveTaskWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Card(
        elevation: 4.0,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Intro',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Pre Study',
                          style: TextStyle(
                            color: Color(0xFF7F7F7F),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      color: PROJECT_GREEN,
                      onPressed: () {},
                      child: Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFDFE2ED).withOpacity(0.2),
                child: ExpansionTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.menu,
                        color: Color(0xFFC6C5CC),
                        size: 12.0,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        '0/1',
                        style: TextStyle(
                          color: Color(0xFFC6C5CC),
                          fontSize: 10.0,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.message,
                            color: Color(0xFFC6C5CC),
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            '3',
                            style: TextStyle(
                              color: Color(0xFFC6C5CC),
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: _isExpanded
                      ? Text(
                          'Hide Details',
                          style: TextStyle(
                            color: Color(0xFFC6C5CC),
                            fontSize: 10.0,
                          ),
                        )
                      : Text(
                          'Show Details',
                          style: TextStyle(
                            color: Color(0xFFC6C5CC),
                            fontSize: 10.0,
                          ),
                        ),
                  onExpansionChanged: (value) {
                    setState(() {
                      _isExpanded = value;
                    });
                  },
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0, bottom: 15.0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    'Questions\nRemaining',
                                    style: TextStyle(
                                        color: Color(0xFFC6C5CC),
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 40.0,
                              ),
                              Expanded(
                                child: Container(
                                  height: 10.0,
                                  color: Color(0xFFDFE2ED),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Questions',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              Text(
                                'In Progress',
                                style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0.1 Getting to know you',
                                style: TextStyle(
                                  color: PROJECT_GREEN,
                                  fontSize: 12.0,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: PROJECT_GREEN,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
