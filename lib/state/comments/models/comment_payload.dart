import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue;
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_mikolaj/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

@immutable
class CommentPayload extends MapView<String, dynamic> {
  // work with firebase fields names
  CommentPayload({
    required String comment,
    required UserId fromUserId,
    required PostId commentedOnPostId,
  }) : super(
          {
            FirebaseFieldName.userId: fromUserId,
            FirebaseFieldName.postId: commentedOnPostId,
            FirebaseFieldName.comment: comment,
            FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
          },
        );
}
