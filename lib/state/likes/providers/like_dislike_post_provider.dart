import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/likes/models/like.dart';
import 'package:instagram_clone_mikolaj/state/likes/models/like_dislike_request.dart';

final likeDislikePostProvider = FutureProvider.autoDispose.family<bool, LikeDislikeRequest>(
  (
    ref,
    LikeDislikeRequest request,
  ) async {
    final query = FirebaseFirestore.instance
        .collection('likes')
        .where(
          'post_id',
          isEqualTo: request.postId,
        )
        .where(
          'user_id',
          isEqualTo: request.likedBy,
        )
        .get();

    // first see if the user has already liked the post or not
    final hasLiked = await query.then(
      (snapshot) => snapshot.docs.isNotEmpty,
    );

    if (hasLiked) {
      // if the user has already liked the post, then unlike it meaning delete the like
      try {
        await query.then((snapshot) async {
          for (final doc in snapshot.docs) {
            await doc.reference.delete();
          }
        });
        return true;
      } catch (_) {
        return false;
      }
    } else {
      // if the user has not liked the post, then like it meaning add a new like
      try {
        final like = Like(
          postId: request.postId,
          likedBy: request.likedBy,
          date: DateTime.now(),
        );
        await FirebaseFirestore.instance.collection('likes').add(
              like,
            );
        return true;
      } catch (_) {
        return false;
      }
    }
  },
);
