import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/image_upload_notifier.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

class DeleteCommentStateNotifier extends StateNotifier<IsLoading> {
  DeleteCommentStateNotifier() : super(false); // calling with not loading by default

  set isLoading(bool value) {
    state = value;
  }

  Future<bool> deleteComment({
    required CommentId commentId,
  }) async {
    isLoading = true;

    try {
      final query = FirebaseFirestore.instance
          .collection('comments')
          .where(FieldPath.documentId, isEqualTo: commentId)
          .limit(1)
          .get();

      await query.then(
        (query) async {
          for (final doc in query.docs) {
            await doc.reference.delete();
          }
        },
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
