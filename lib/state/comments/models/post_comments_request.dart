import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

// how it should fetch comments on a post
@immutable
class RequestForPostAndComments {
  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const RequestForPostAndComments({
    required this.postId,
    this.sortByCreatedAt = true,
    this.dateSorting = DateSorting.newestOnTop,
    this.limit,
  });

  @override
  String toString() => 'RequestForPostAndComments(postId: $postId, '
      'sortByCreatedAt: $sortByCreatedAt, '
      'dateSorting: $dateSorting, '
      'limit: $limit)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestForPostAndComments &&
          runtimeType == other.runtimeType &&
          postId == other.postId &&
          dateSorting == other.dateSorting &&
          limit == other.limit &&
          sortByCreatedAt == other.sortByCreatedAt;

  @override
  int get hashCode => Object.hashAll([
        postId,
        dateSorting,
        limit,
        sortByCreatedAt,
      ]);
}

enum DateSorting {
  newestOnTop,
  oldestOnTop,
}

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocuments = toList()
        ..sort(
          (a, b) {
            switch (request.dateSorting) {
              case DateSorting.newestOnTop:
                return b.createdAt.compareTo(a.createdAt);
              case DateSorting.oldestOnTop:
                return a.createdAt.compareTo(b.createdAt);
            }
          },
        );
      return sortedDocuments;
    } else {
      return this;
    }
  }
}
