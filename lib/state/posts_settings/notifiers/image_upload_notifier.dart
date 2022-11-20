import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as imageLib;
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post_payload.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/models/post_setting.dart';
import 'package:uuid/uuid.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType type,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required UserId userId,
  }) async {
    late Uint8List thumbnailUint8List;
    final double aspectRatio;

    switch (type) {
      case FileType.image:
        // create the image out of the file
        final fileAsImage = imageLib.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          return false;
        }
        // create thumbnail
        final thumbnail = imageLib.copyResize(fileAsImage, width: 150);
        aspectRatio = thumbnail.width / thumbnail.height;
        final thumbnailData = imageLib.encodeJpg(thumbnail);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);
        break;
      case FileType.video:
        //TODO
        isLoading = false;
        return false;
    }

    // calculate the aspect ratio
    // FIXME final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    final fileName = const Uuid().v4();
    final thumbnailRef = FirebaseStorage.instance.ref().child(userId).child('thumbnails').child(fileName);
    final originalFileRef = FirebaseStorage.instance.ref().child(userId).child('images').child(fileName);
    try {
      // upload the thumbnail
      final thumbnailUploadTask = await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      // upload the original image
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      final postPayload = PostPayload(
        userId: userId,
        message: message,
        type: type,
        fileUrl: await originalFileRef.getDownloadURL(),
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        aspectRatio: aspectRatio, //FIXME thumbnailAspectRatio,
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

typedef IsLoading = bool;
