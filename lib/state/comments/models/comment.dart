import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId fromUserId; // comment was done by this UserId
  final PostId commentedOnPostId; // comment was on this PostId

  Comment(
    Map<String, dynamic> json, {
    required this.id,
  })  : comment = json['comment'] as String,
        createdAt = (json['created_at'] as Timestamp).toDate(),
        fromUserId = json['uid'] as UserId,
        commentedOnPostId = json['post_id'] as PostId;

  @override
  String toString() {
    return 'Comment{id: $id, comment: $comment, createdAt: $createdAt, fromUserId: $fromUserId, commentedOnPostId: $commentedOnPostId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          comment == other.comment &&
          createdAt == other.createdAt &&
          fromUserId == other.fromUserId &&
          commentedOnPostId == other.commentedOnPostId;

  @override
  int get hashCode => Object.hashAll([
        id,
        comment,
        createdAt,
        fromUserId,
        commentedOnPostId,
      ]);
}
