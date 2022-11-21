import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as image_lib; // comes from image: ^3.2.2
import 'package:instagram_clone_mikolaj/state/image_upload/exception/could_not_build_thumbnail_exception.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/extension/get_aspect_ratio.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post_payload.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/models/post_setting.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) {
    state = value;
  }

  Future<bool> upload({
    required File file,
    required FileType type,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;

    late Uint8List thumbnailUint8List;

    switch (type) {
      case FileType.image:
        // create the image out of the file
        final fileAsImage = image_lib.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotDecodeImageException();
        }
        // create thumbnail
        final thumbnail = image_lib.copyResize(fileAsImage, width: 150);
        final thumbnailData = image_lib.encodeJpg(thumbnail);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          quality: 75,
        );
        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          // setting frame from video as thumbnail for the post
          thumbnailUint8List = thumb;
        }
        break;
    }

    // calculate the aspect ratio
    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    final fileName = const Uuid().v4();

    // comes from the firebase_storage: ^10.0.1 Storage
    final thumbnailRef = FirebaseStorage.instance.ref().child(userId).child('thumbnails').child(fileName);
    final originalFileRef = FirebaseStorage.instance.ref().child(userId).child(type.collectionName).child(fileName);
    try {
      // upload the thumbnail in transaction
      final thumbnailUploadTask = await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      // upload the original image
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      // upload the post itself
      final postPayload = PostPayload(
        userId: userId,
        message: message,
        type: type,
        fileUrl: await originalFileRef.getDownloadURL(),
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        aspectRatio: thumbnailAspectRatio,
        postSettings: postSettings,
        fileName: fileName,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
      );
      await FirebaseFirestore.instance.collection('posts').add(postPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}

/*
class MyImageUploader extends StateNotifier<bool>{} // not telling us anything about this bool
class MyImageUploader extends StateNotifier<IsLoading>{} // with type def of IsLoading, we know what this bool is
*/
typedef IsLoading = bool;
