import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

@immutable
class LikeDislikeRequest {
  final UserId likedBy; // which UserId liked it
  final PostId postId; // which post was liked/disliked PostId

  const LikeDislikeRequest({
    required this.likedBy,
    required this.postId,
  });

  @override
  String toString() {
    return 'LikeDislikeRequest{likedBy: $likedBy, postId: $postId}';
  }
}
