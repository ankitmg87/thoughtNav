class Comment {
  String avatarURL;
  String alias;
  String userName;
  String timeElapsed;
  String date;
  String commentStatement;

  Comment({
    this.avatarURL,
    this.alias,
    this.userName,
    this.timeElapsed,
    this.date,
    this.commentStatement,
  });

  Map<String, dynamic> toMap () {
    var comment = <String, dynamic>{};

    comment['avatarURL'] = avatarURL;
    comment['alias'] = alias;
    comment['userName'] = userName;
    comment['timeElapsed'] = timeElapsed;
    comment['date'] = date;
    comment['commentStatement'] = commentStatement;

    return comment;
  }

  Comment.fromMap(Map<String, dynamic> comment){
    avatarURL = comment['avatarURL'];
    alias = comment['alias'];
    userName = comment['userName'];
    timeElapsed = comment['timeElapsed'];
    date = comment['date'];
    commentStatement = comment['commentStatement'];
  }

}
