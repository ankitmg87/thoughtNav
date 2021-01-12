import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:thoughtnav/constants/color_constants.dart';
import 'package:thoughtnav/services/researcher_and_moderator_firestore_service.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {

  final moderatorService = ResearcherAndModeratorFirestoreService();

  Response response;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              onPressed: () async {
                response = await moderatorService.sendEmail();
                setState(() {});
              },
              color: PROJECT_GREEN,
              child: Text('Send Email', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              response != null ? '${response.statusCode} ${response.body.toString()}' : 'Response is null',
            ),
          ],
        ),
      ),
    );
  }
}
