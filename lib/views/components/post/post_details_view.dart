import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;

  const PostDetailsView({Key? key, required this.post}) : super(key: key);

  @override
  ConsumerState<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      sortByCreatedAt: true,
      dateSorting: DateSorting.newestOnTop,
      limit: 10,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('userId: ${widget.post.userId}'),
            Text('postId: ${widget.post.postId}'),
          ],
        ),
      ),
    );
  }
}

typedef CommentId = String;
typedef PostId = String;
