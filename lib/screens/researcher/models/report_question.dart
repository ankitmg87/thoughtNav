class ReportQuestion {
  String questionNumber;
  String questionTitle;
  String questionStatement;
  List<Map<String, dynamic>> reportResponses;
  ReportQuestion({
    this.questionNumber,
    this.questionTitle,
    this.questionStatement,
    this.reportResponses,
  });
  Map toMap(ReportQuestion reportQuestion){
    var reportQuestionMap = <String, dynamic>{};
    reportQuestionMap['questionNumber'] = reportQuestion.questionNumber;
    reportQuestionMap['questionTitle'] = reportQuestion.questionTitle;
    reportQuestionMap['questionStatement'] = reportQuestion.questionStatement;
    reportQuestionMap['reportResponses'] = reportQuestion.reportResponses;
    return reportQuestionMap;
  }
}