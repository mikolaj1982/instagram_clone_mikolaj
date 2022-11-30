import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/post_with_comments.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';

final specificPostWithCommentsProvider = StreamProvider.autoDispose.family<PostWithComments, RequestForPostAndComments>(
  (
    AutoDisposeStreamProviderRef<PostWithComments> ref,
    RequestForPostAndComments request,
  ) {
    final controller = StreamController<PostWithComments>();

    Post? post;
    Iterable<Comment>? comments;

    void notify() {
      final localPost = post;
      if (localPost == null) {
        return;
      }

      final localComments = (comments ?? []).applySortingFrom(
        request,
      );
      final result = PostWithComments(
        post: localPost,
        comments: localComments,
      );
      controller.sink.add(result);
    }

    // watch changes to the post
    final postSub =
        FirebaseFirestore.instance.collection('posts').where(FieldPath.documentId).limit(1).snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          post = null;
          comments = null;
          notify();
          return;
        }
        final doc = snapshot.docs.first;
        if (doc.metadata.hasPendingWrites) {
          return;
        }
        post = Post(
          postId: doc.id,
          json: doc.data(),
          createdAt: doc.data()['created_at'],
        );
        notify();
      },
    );

    // watch changes to the comments
    final commentsQuery = FirebaseFirestore.instance
        .collection('comments')
        .where('post_id', isEqualTo: request.postId)
        .orderBy('created_at', descending: true);

    final limitedCommentsQuery = request.limit != null ? commentsQuery.limit(request.limit!) : commentsQuery;

    final commentsSub = limitedCommentsQuery.snapshots().listen(
      (snapshot) {
        comments = snapshot.docs
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Comment(
                doc.data(),
                id: doc.id,
              ),
            );
        notify();
      },
    );

    ref.onDispose(() {
      postSub.cancel();
      commentsSub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
