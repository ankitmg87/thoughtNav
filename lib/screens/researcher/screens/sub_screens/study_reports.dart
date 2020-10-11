import 'package:flutter/material.dart';

class StudyReports extends StatefulWidget {
  @override
  _StudyReportsState createState() => _StudyReportsState();
}

class _StudyReportsState extends State<StudyReports> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Study reports',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
