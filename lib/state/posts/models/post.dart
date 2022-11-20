import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/models/post_setting.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final String message;
  final DateTime createdAt;
  final String thumbnailUrl;
  final String fileUrl;
  final FileType fileType;
  final String fileName;
  final double aspectRatio;
  final String thumbnailStorageId;
  final String originalFileStorageId;
  final Map<PostSetting, bool> postSettings;

  Post({
    required this.postId,
    required Map<String, dynamic> json,
  })  : userId = json[PostKey.userId],
        message = json[PostKey.message],
        thumbnailUrl = json[PostKey.thumbnailUrl],
        fileUrl = json[PostKey.fileUrl],
        fileName = json[PostKey.fileName],
        aspectRatio = json[PostKey.aspectRatio],
        thumbnailStorageId = json[PostKey.thumbnailStorageId],
        originalFileStorageId = json[PostKey.originalFileStorageId],
        createdAt = (json[PostKey.createdAt] as Timestamp).toDate(),
        fileType = FileType.values.firstWhere(
          (fileType) => fileType.name == json[PostKey.fileType],
          orElse: () => FileType.image,
        ),
        postSettings = {
          for (final entry in json[PostKey.postSettings].entries)
            PostSetting.values.firstWhere(
              (element) => element.storageKey == entry.key,
            ): entry.value,
        };

  bool get allowsLikes => postSettings[PostSetting.allowLikes] ?? false;

  bool get allowsComments => postSettings[PostSetting.allowComments] ?? false;

  @override
  String toString() {
    return 'Post {postId: $postId, userId: $userId, message: $message, createdAt: $createdAt, thumbnailUrl: $thumbnailUrl, fileUrl: $fileUrl, fileType: $fileType, fileName: $fileName, aspectRatio: $aspectRatio, thumbnailStorageId: $thumbnailStorageId, originalFileStorageId: $originalFileStorageId, postSettings: $postSettings}';
  }
}

@immutable
class PostKey {
  static const userId = 'uid';
  static const message = 'message';
  static const createdAt = 'created_at';
  static const thumbnailUrl = 'thumbnail_url';
  static const fileUrl = 'file_url';
  static const fileType = 'file_type';
  static const fileName = 'file_name';
  static const aspectRatio = 'aspect_ratio';
  static const postSettings = 'post_settings';
  static const thumbnailStorageId = 'thumbnail_storage_id';
  static const originalFileStorageId = 'original_file_storage_id';

  const PostKey._();
}
