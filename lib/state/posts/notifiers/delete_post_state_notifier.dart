import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/constants/firebase_collectiion_name.dart';
import 'package:instagram_clone_mikolaj/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/image_upload_notifier.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false); // calling with not loading by default

  set isLoading(bool value) => state = value;

  Future<bool> deletePost({
    required Post post,
  }) async {
    try {
      isLoading = true;

      debugPrint('Deleting post: ${post.postId}');

      // delete the post's thumbnail
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();
      debugPrint('Deleting post\'s thumbnail');

      // delete the post's original file (video or image)
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.originalFileStorageId)
          .delete();
      debugPrint('Deleting post\'s original file');

      // delete all comments associated with this post
      await _deleteAllDocuments(
        inCollection: FirebaseCollectionName.comments,
        postId: post.postId,
      );
      debugPrint('Deleting post\'s all comments');

      // delete all likes associated with this post
      await _deleteAllDocuments(
        inCollection: FirebaseCollectionName.likes,
        postId: post.postId,
      );
      debugPrint('Deleting post\'s all likes');

      // finally delete the post itself
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(
            FieldPath.documentId,
            isEqualTo: post.postId,
          )
          .limit(1)
          .get();
      for (final post in postInCollection.docs) {
        debugPrint('Deleting post itself!');
        await post.reference.delete();
      }

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocuments({
    required PostId postId,
    required String inCollection,
  }) async {
    return FirebaseFirestore.instance.runTransaction(
      maxAttempts: 3,
      timeout: const Duration(
        seconds: 20,
      ),
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(
              FirebaseFieldName.postId,
              isEqualTo: postId,
            )
            .get();
        for (final doc in query.docs) {
          transaction.delete(doc.reference);
        }
      },
    );
  }
}
