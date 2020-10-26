import 'package:thoughtnav/screens/researcher/models/participant.dart';

class Group {
  String groupName;
  String internalGroupLabel;
  List<Participant> participants;

  Group({
    this.groupName,
    this.internalGroupLabel,
    this.participants,
  });

  Group.fromMap(Map<String, dynamic> group){

  }

}
