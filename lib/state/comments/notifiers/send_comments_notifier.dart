import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment_payload.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/image_upload_notifier.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

class SendCommentNotifier extends StateNotifier<IsLoading> {
  SendCommentNotifier() : super(false); // calling with not loading by default

  set isLoading(bool value) {
    state = value;
  }

  Future<bool> sendComment({
    required UserId fromUserId,
    required String comment,
    required PostId commentedOnPostId,
  }) async {
    isLoading = true;

    // define payload
    final payload = CommentPayload(
      comment: comment,
      fromUserId: fromUserId,
      commentedOnPostId: commentedOnPostId,
    );
    debugPrint('payload: $payload');

    try {
      // persist payload
      await FirebaseFirestore.instance.collection('comments').add(payload);

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
