import 'package:thoughtnav/screens/researcher/models/question.dart';

class Topic {
  String topicName;
  String date;
  List<Question> questions;

  Topic({
    this.topicName,
    this.date,
    this.questions,
  });
}
