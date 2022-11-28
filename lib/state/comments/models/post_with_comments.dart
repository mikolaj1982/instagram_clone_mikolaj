import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';

@immutable
class PostWithComments {
  final Post post;
  final Iterable<Comment> comments;

  const PostWithComments({
    required this.post,
    required this.comments,
  });

  @override
  String toString() {
    return 'PostWithComment(post: $post, comments: $comments)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostWithComments && runtimeType == other.runtimeType && post == other.post && comments == other.comments;

  @override
  int get hashCode => Object.hashAll([
        post,
        comments,
      ]);
}
