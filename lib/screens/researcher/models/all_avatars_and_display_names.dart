import 'package:thoughtnav/models/avatar_and_display_name.dart';

// class AllAvatarsAndDisplayNames {
//
//   final List<AvatarAndDisplayName> _avatarAndDisplayNameList = [
//     AvatarAndDisplayName(
//       id: '11.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F11.png?alt=media&token=f8bb82b3-4244-41ed-a028-a9c3d46c425f',
//       displayName: '11.png',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '12.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F12.png?alt=media&token=dd62a219-8273-47cf-8b5e-4de6e87b8af5',
//       displayName: '12.png',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '13.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F13.png?alt=media&token=0c66abd7-f069-419c-b66d-d6d704b542f0',
//       displayName: 'Ninja',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '14.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F14.png?alt=media&token=259fff5b-1e94-4cb5-9dae-9b7c4c9afd9d',
//       displayName: 'Magician',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '15.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F15.png?alt=media&token=60b4abf4-b0f9-4794-86fa-df5c601b99c2',
//       displayName: 'Englishman',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '16.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F16.png?alt=media&token=e4dc5608-d325-483b-b748-6438b079a851',
//       displayName: 'Flash',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '17.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F17.png?alt=media&token=6cedf7ac-4bd8-44cc-ac65-20d79b6c9738',
//       displayName: 'Hagrid',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '18.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F18.png?alt=media&token=ee2e8e3f-564c-4af7-81ec-6e3f6adf94f8',
//       displayName: 'Draco',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '19.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F19.png?alt=media&token=480591c2-54ed-4a21-b240-c1371919a30e',
//       displayName: 'The Doctor',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '20.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F20.png?alt=media&token=44dd3e80-3dd5-4daa-a074-1a21b5830939',
//       displayName: 'Superman',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '21.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F21.png?alt=media&token=08d37512-200c-4116-a0f6-6417ba4b9fdd',
//       displayName: 'Deadpool',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '22.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F22.png?alt=media&token=7f48c6a3-d8f7-400d-985d-f42eb77775c7',
//       displayName: 'Cyborg',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '23.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F23.png?alt=media&token=4ec2f10d-73c0-4b01-9800-b4e1163d2919',
//       displayName: 'Gruffy',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '24.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F24.png?alt=media&token=5b3f7daa-478c-4551-bcb6-19ce5e0dc811',
//       displayName: 'Santa',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '25.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F25.png?alt=media&token=005b7b66-2ddf-496b-ac5b-ba94e1b2acb6',
//       displayName: 'Beast',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '26.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F26.png?alt=media&token=30bdf3aa-ea37-4dcf-a281-b10053109541',
//       displayName: 'Laurel',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: '27.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2F27.png?alt=media&token=5fb8a46a-1724-4d4a-8259-549daa370b1f',
//       displayName: 'Quarterback',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'batman.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fbatman.png?alt=media&token=1f96d810-aaff-4b33-8fe0-a5253a363566',
//       displayName: 'Batman',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'blue.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fblue.png?alt=media&token=98f74611-f57a-4879-8be2-c771c602ece3',
//       displayName: 'Blue',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'he_man.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fhe_man.png?alt=media&token=4db21514-130d-4881-a014-f08c1ad26acd',
//       displayName: 'He-Man',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'lego.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Flego.png?alt=media&token=d6977b8e-6957-4af8-b139-c358ab7fb922',
//       displayName: 'Lego',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'mr_t.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fmr_t.png?alt=media&token=5afeecf7-9a64-4425-b059-0be094a2d049',
//       displayName: 'Mr. T',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'mummy.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fmummy.png?alt=media&token=7ebec049-7c10-4f0e-880c-d73a3252e3d7',
//       displayName: 'Mummy',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'queen.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fqueen.png?alt=media&token=5f976f60-26da-4937-808a-bfc08773cbdd',
//       displayName: 'Queen',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'spiderman.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fspiderman.png?alt=media&token=c11f14ec-afe2-47ec-9d97-a51af878d2e2',
//       displayName: 'Spiderman',
//       selected: false,
//     ),
//     AvatarAndDisplayName(
//       id: 'wolverine.png',
//       avatarURL: 'https://firebasestorage.googleapis.com/v0/b/thoughtnav-51841.appspot.com/o/avatars%2Fwolverine.png?alt=media&token=339a799a-52c6-4441-aff9-7989e95fd806',
//       displayName: 'Wolverine',
//       selected: false,
//     ),
//   ];
//
//   List<AvatarAndDisplayName> getAvatarAndDisplayNameList () {
//     return _avatarAndDisplayNameList;
//   }
//
//
//
// }