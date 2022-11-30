import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';

import 'compact_comment_tile.dart';

class CompactCommentsColumn extends StatelessWidget {
  final Iterable<Comment> comments;

  const CompactCommentsColumn({
    Key? key,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments
            .map((comment) => CompactCommentTile(
                  comment: comment,
                ))
            .toList(),
      ),
    );
  }
}
