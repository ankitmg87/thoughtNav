class AvatarAndDisplayName {
  String id;
  String avatarURL;
  String displayName;
  bool selected;

  AvatarAndDisplayName({
    this.id,
    this.avatarURL,
    this.displayName,
    this.selected,
  });

  Map<String, dynamic> toMap() {
    var avatarAndDisplayNameMap = <String, dynamic>{};

    avatarAndDisplayNameMap['id'] = id;
    avatarAndDisplayNameMap['avatarURL'] = avatarURL;
    avatarAndDisplayNameMap['displayName'] = displayName;
    avatarAndDisplayNameMap['selected'] = selected;

    return avatarAndDisplayNameMap;
  }

  AvatarAndDisplayName.fromMap(
    Map<String, dynamic> avatarAndDisplayNameMap,
  ) {
    id = avatarAndDisplayNameMap['id'];
    avatarURL = avatarAndDisplayNameMap['avatarURL'];
    displayName = avatarAndDisplayNameMap['displayName'];
    selected = avatarAndDisplayNameMap['selected'];
  }
}

// List<AvatarAndDisplayName> avatarAndDisplayNameList = [
//   // 1
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FAlien.png?alt=media&token=7916fe8b-0981-4ccb-9ffb-9888b148abc5',
//     selected: false,
//     id: 'Alien.png',
//     displayName: 'Alien',
//   ),
//   // 2
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FArtist.png?alt=media&token=d5c23ba6-5c58-4623-9b37-3c5f9e94cbd2',
//     selected: false,
//     id: 'Artist.png',
//     displayName: 'Artist',
//   ),
//   // 3
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FBandit.png?alt=media&token=6e91db5d-34c0-4dc3-8405-648fb2498935',
//     selected: false,
//     id: 'Bandit.png',
//     displayName: 'Bandit',
//   ),
//   // 4
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FBatgirl.png?alt=media&token=9f08bf5e-76c3-4b32-9543-6d0fff865ea6',
//     selected: false,
//     id: 'Batgirl.png',
//     displayName: 'Batgirl',
//   ),
//   // 5
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FBatman.png?alt=media&token=b579a40f-d719-43bc-b845-68843a7164bf',
//     selected: false,
//     id: 'Batman.png',
//     displayName: 'Batman',
//   ),
//   // 6
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FBlack%20Panther.png?alt=media&token=5fab9fa8-49f3-4fc4-89f1-ed61518088d8',
//     selected: false,
//     id: 'Black Panther.png',
//     displayName: 'Black Panther',
//   ),
//   // 7
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FBlack%20Widow.png?alt=media&token=a0ba1c38-d078-4fbc-90bb-d8e43e1235dd',
//     selected: false,
//     id: 'Black Widow.png',
//     displayName: 'Black Widow',
//   ),
//   // 8
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FBlackbeard.png?alt=media&token=fd2d050a-5a9b-4b5c-a2fd-ddf63acc9a81',
//     selected: false,
//     id: 'Blackbeard.png',
//     displayName: 'Blackbeard',
//   ),
//   // 9
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FCaptain%20Jack.png?alt=media&token=89838b09-84a0-4449-a7ab-9b5308ffea52',
//     selected: false,
//     id: 'Captain Jack.png',
//     displayName: 'Captain Jack',
//   ),
//   // 10
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FCat%20Woman.png?alt=media&token=00255202-8653-43d6-a731-ce69c91f2ee9',
//     selected: false,
//     id: 'Cat Woman.png',
//     displayName: 'Cat Woman',
//   ),
//   // 11
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FChaplin.png?alt=media&token=f957b5ca-9466-45a3-8a90-01a249966fb9',
//     selected: false,
//     id: 'Chaplin.png',
//     displayName: 'Chaplin',
//   ),
//   // 12
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FChef.png?alt=media&token=c5142ec7-0e56-490c-93db-0d534f1dfe84',
//     selected: false,
//     id: 'Chef.png',
//     displayName: 'Chef',
//   ),
//   // 13
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FClark%20Kent.png?alt=media&token=5e39d980-334e-469c-bdbc-97a712883ba5',
//     selected: false,
//     id: 'Clark Kent.png',
//     displayName: 'Clark Kent',
//   ),
//   // 14
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FClown.png?alt=media&token=8cff24b2-690a-414c-a249-2d2cefa311ce',
//     selected: false,
//     id: 'Clown.png',
//     displayName: 'Clown',
//   ),
//   // 15
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FCowgirl.png?alt=media&token=f8353d43-14f8-466e-98cf-ae9fc6c37c56',
//     selected: false,
//     id: 'Cowgirl.png',
//     displayName: 'Cowgirl',
//   ),
//   // 16
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FCyberman.png?alt=media&token=aaa2b8d9-8e54-4d4e-8a68-e9d8f6d4f4ff',
//     selected: false,
//     id: 'Cyberman.png',
//     displayName: 'Cyberman',
//   ),
//   // 17
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FDeadpool.png?alt=media&token=cd10d23c-a7d1-4909-8ec5-3b9768ade3ba',
//     selected: false,
//     id: 'Deadpool.png',
//     displayName: 'Deadpool',
//   ),
//   // 18
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FEinstein.png?alt=media&token=9e9b9dbf-a6c7-4b38-841d-54b6c9e74ef9',
//     selected: false,
//     id: 'Einstein.png',
//     displayName: 'Einstein',
//   ),
//   // 19
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FFarmer.png?alt=media&token=62127645-6296-440c-8e0f-02d47bbabf17',
//     selected: false,
//     id: 'Farmer.png',
//     displayName: 'Farmer',
//   ),
//   // 20
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FFirefighter.png?alt=media&token=7e2edb0f-cbdf-4fec-8425-2f03e0700058',
//     selected: false,
//     id: 'Firefighter.png',
//     displayName: 'Firefighter',
//   ),
//   // 21
//   AvatarAndDisplayName(
//     avatarURL:
//         'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FGeneral.png?alt=media&token=a30fa146-02b1-4eb8-9839-500adc1d5393',
//     selected: false,
//     id: 'General.png',
//     displayName: 'General',
//   ),
//   // 22
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FInnvator.png?alt=media&token=ad695d5d-8567-4aa5-813e-dc8d69f22c21',
//     selected: false,
//     id: 'Innovator.png',
//     displayName: 'Innovator',
//   ),
//   // 23
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FInvestigator.png?alt=media&token=c07fb626-fe04-468c-b567-7173099e2ece',
//     selected: false,
//     id: 'Investigator.png',
//     displayName: 'Investigator',
//   ),
//   // 24
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FMad%20Hatter.png?alt=media&token=8559b6f8-d86f-4e66-bff9-724b8aea4db0',
//     selected: false,
//     id: 'Mad Hatter.png',
//     displayName: 'Mad Hatter',
//   ),
//   // 25
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FMarilyn.png?alt=media&token=782d1519-34d0-4e6e-8633-f3ad69b2f3b5',
//     selected: false,
//     id: 'Marilyn.png',
//     displayName: 'Marilyn',
//   ),
//   // 26
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FMorpheus.png?alt=media&token=28c302cb-f3f4-4d9f-99b2-13068caab1d5',
//     selected: false,
//     id: 'Morpheus.png',
//     displayName: 'Morpheus',
//   ),
//   // 27
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FNefertiti.png?alt=media&token=e480e79f-aca5-4bda-b3a2-32a9aab3dd68',
//     selected: false,
//     id: 'Nefertiti.png',
//     displayName: 'Nefertiti',
//   ),
//   // 28
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FNeo.png?alt=media&token=97c22ef6-578b-4aaf-8669-388d3e9aac41',
//     selected: false,
//     id: 'Neo.png',
//     displayName: 'Neo',
//   ),
//   // 29
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FNinja.png?alt=media&token=d90396eb-bfeb-44dc-9681-f0cc2798ebcc',
//     selected: false,
//     id: 'Ninja.png',
//     displayName: 'Ninja',
//   ),
//   // 30
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FPaleontologist.png?alt=media&token=677bfcf0-09ea-4f63-835f-13218666b966',
//     selected: false,
//     id: 'Paleontologist.png',
//     displayName: 'Paleontologist',
//   ),
//   // 31
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FParisian.png?alt=media&token=583291a2-2b68-4e1e-a76a-240df9f348fe',
//     selected: false,
//     id: 'Parisian.png',
//     displayName: 'Parisian',
//   ),
//   // 32
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FPharoah.png?alt=media&token=b6b80cd0-172e-44e6-89b0-2a5858c50ff6',
//     selected: false,
//     id: 'Pharaoh.png',
//     displayName: 'Pharaoh',
//   ),
//   // 33
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FPhysician.png?alt=media&token=93d83271-29e1-488f-819b-f16ccb097c47',
//     selected: false,
//     id: 'Physician.png',
//     displayName: 'Physician',
//   ),
//   // 34
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FPirate.png?alt=media&token=aef90f39-013f-4a46-9df9-9c4f96036f88',
//     selected: false,
//     id: 'Pirate.png',
//     displayName: 'Pirate',
//   ),
//   // 35
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FPop%20Star.png?alt=media&token=7668948c-a8ab-4dde-a269-a96212595356',
//     selected: false,
//     id: 'Pop Star.png',
//     displayName: 'Pop Star',
//   ),
//   // 36
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FQueen.png?alt=media&token=03ffed12-1fd0-40b6-9e42-572ace234502',
//     selected: false,
//     id: 'Queen.png',
//     displayName: 'Queen',
//   ),
//   // 37
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FRapper.png?alt=media&token=8a16d9fd-739a-4263-8fbd-13400c31d086',
//     selected: false,
//     id: 'Rapper.png',
//     displayName: 'Rapper',
//   ),
//   // 38
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FRingmaster.png?alt=media&token=c1e6be23-3bbf-419e-b2a1-56c8dabc8dae',
//     selected: false,
//     id: 'Ringmaster.png',
//     displayName: 'Ringmaster',
//   ),
//   // 39
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FRobot.png?alt=media&token=b35e7ff5-4659-4b28-a657-2f6a95a1a722',
//     selected: false,
//     id: 'Robot.png',
//     displayName: 'Robot',
//   ),
//   // 40
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FRock%20Star.png?alt=media&token=9e6021d1-caf7-45eb-b581-693056053e8b',
//     selected: false,
//     id: 'Rock Star.png',
//     displayName: 'Rock Star',
//   ),
//   // 41
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FScuba%20Diver.png?alt=media&token=36163f31-bb16-430d-8a13-85d29d0a37a9',
//     selected: false,
//     id: 'Scuba Diver.png',
//     displayName: 'Scuba Diver',
//   ),
//   // 42
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FSea%20Dog.png?alt=media&token=cd8869ba-e312-4954-977e-715ce2c49fa4',
//     selected: false,
//     id: 'Sea Dog.png',
//     displayName: 'Sea Dog',
//   ),
//   // 43
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FSecret%20Agent.png?alt=media&token=46380b5c-74b6-4ba0-b761-8e3a2167842b',
//     selected: false,
//     id: 'Secret Agent.png',
//     displayName: 'Secret Agent',
//   ),
//   // 44
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FSherlock.png?alt=media&token=df6838dc-06dd-49a5-81e3-ccf2764d2731',
//     selected: false,
//     id: 'Sherlock.png',
//     displayName: 'Sherlock',
//   ),
//   // 45
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FShowman.png?alt=media&token=048afdca-554d-4ce6-a5d5-50ddce0f74e8',
//     selected: false,
//     id: 'Showman.png',
//     displayName: 'Showman',
//   ),
//   // 46
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FSpiderman.png?alt=media&token=3864f7ff-1370-4e68-971b-add00d6c1b93',
//     selected: false,
//     id: 'Spiderman.png',
//     displayName: 'Spiderman',
//   ),
//   // 47
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FTesla.png?alt=media&token=452efc32-38b8-42c5-af51-ed8f589bbfe6',
//     selected: false,
//     id: 'Tesla.png',
//     displayName: 'Tesla',
//   ),
//   // 48
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FTrinity.png?alt=media&token=2c195283-ae31-4c38-85df-d65321e5a86a',
//     selected: false,
//     id: 'Trinity.png',
//     displayName: 'Trinity',
//   ),
//   // 49
//   AvatarAndDisplayName(
//     avatarURL:
//     'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars_new%2FWatson.png?alt=media&token=d1f5f873-278f-4ca8-b710-cf228796ae85',
//     selected: false,
//     id: 'Watson.png',
//     displayName: 'Watson',
//   ),
// ];
