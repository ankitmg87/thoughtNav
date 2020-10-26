import 'package:thoughtnav/screens/researcher/models/group.dart';

enum StudyStatus{
  ACTIVE,
  COMPLETED,
  DRAFT,
}

class Study {
  String studyUID;
  String studyName;

  String internalStudyLabel;
  String studyStatus;
  String activeParticipants;
  String totalResponses;
  String beginDate;
  String endDate;

  bool isDraft;

  String masterPassword;
  String commonInviteMessage;
  String specializedInviteMessage;
  String introPageMessage;
  String studyClosedMessage;

  List<dynamic> categories;
  List<dynamic> groups;
  List<dynamic> topics;

  Study({
    this.studyUID,
    this.studyName,
    this.internalStudyLabel,
    this.studyStatus,
    this.activeParticipants,
    this.totalResponses,
    this.beginDate,
    this.endDate,
    this.isDraft,
    this.masterPassword,
    this.commonInviteMessage,
    this.specializedInviteMessage,
    this.introPageMessage,
    this.studyClosedMessage,
    this.categories,
    this.groups,
    this.topics,
  });

  Map<String, dynamic> toMap() {
    var study = <String, dynamic>{};

    study['studyUID'] = studyUID;
    study['studyName'] = studyName;
    study['internalStudyLabel'] = internalStudyLabel;
    study['studyStatus'] = studyStatus;
    study['activeParticipants'] = activeParticipants;
    study['totalResponses'] = totalResponses;
    study['startDate'] = beginDate;
    study['endDate'] = endDate;
    study['isDraft'] = isDraft ?? true;
    study['masterPassword'] = masterPassword;
    study['commonInviteMessage'] = commonInviteMessage;
    study['specializedInviteMessage'] = specializedInviteMessage;
    study['studyClosedMessage'] = studyClosedMessage;
    study['categories'] = categories;
    study['groups'] = groups;
    study['topics'] = topics;

    return study;
  }

  Study.fromMap(Map<String, dynamic> study) {
    studyUID = study['studyUID'];
    studyName = study['studyName'];
    internalStudyLabel = study['internalStudyLabel'];
    studyStatus = study['studyStatus'];
    activeParticipants = study['activeParticipants'];
    totalResponses = study['totalResponses'];
    beginDate = study['startDate'] ?? '';
    endDate = study['endDate'] ?? '';
    isDraft = study['isDraft'];
    masterPassword = study['masterPassword'];
    commonInviteMessage = study['commonInviteMessage'];
    specializedInviteMessage = study['specializedInviteMessage'];
    studyClosedMessage = study['studyClosedMessage'];
    categories = study['categories'];
    groups = study['groups'];
    topics = study['topics'];
  }

  /// Delete this section later

  Study.testStudy() {
    isDraft = false;
    studyStatus = StudyStatus.ACTIVE.toString();
    studyUID = 'studyUID';
    studyName = 'Power Wheelchair ADL Study';
    internalStudyLabel = '';
    masterPassword = 'misterModerator';
    beginDate = 'Dec 10, 2020';
    endDate = 'Dec 20, 2020';
    introPageMessage = _welcomeInstructions();
    studyClosedMessage = _studyEndMessage();
    commonInviteMessage = _commonInviteMessage();
    categories = <String>[
      'Lifestyle', 'Health', 'Futures'
    ];
    groups = <Group>[
      Group(
        groupName: 'Administrators',
        internalGroupLabel: '',
      ),
      Group(
        groupName: 'Client',
        internalGroupLabel: '',
      ),
      Group(
        groupName: 'Group 1',
        internalGroupLabel: 'bleh',
      ),
      Group(
        groupName: 'Group 2',
        internalGroupLabel: 'meh',
      ),
      Group(
        groupName: 'Group 3',
        internalGroupLabel: 'boo',
      ),
      Group(
        groupName: 'Group 4',
        internalGroupLabel: 'bhish',
      ),
      Group(
        groupName: 'Group 5',
        internalGroupLabel: 'blahh',
      ),
      Group(
        groupName: 'Group 6',
        internalGroupLabel: 'wham',
      ),
      Group(
        groupName: 'Group 7',
        internalGroupLabel: 'slam',
      ),
    ];
  }

  String _welcomeInstructions() {
    return 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?';
  }

  String _studyEndMessage(){
    return 'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?';
  }

  String _commonInviteMessage() {
    return 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.';
  }

  /// End of test section

}

/// Study will be uploaded then it will return a uid. on the basis of that uid
/// topics, users and categories will be added to the study

/// Convert topic.toMap to topic object. Then put it in study object
