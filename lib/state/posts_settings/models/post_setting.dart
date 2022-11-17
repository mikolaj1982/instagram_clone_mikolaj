import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';

enum PostSetting {
  // 2 enum cases allowLikes and allowComments
  allowLikes(
    title: Strings.allowLikesTitle,
    description: Strings.allowCommentsDescription,
    storageKey: Strings.allowLikesStorageKey, //  'allow_likes';
  ),
  allowComments(
    title: Strings.allowCommentsTitle,
    description: Strings.allowCommentsDescription,
    storageKey: Strings.allowCommentsStorageKey, // 'allow_comments'
  );

  final String title;
  final String description;

  //firebase storage key
  final String storageKey;

  const PostSetting({
    required this.description,
    required this.title,
    required this.storageKey,
  });
}
