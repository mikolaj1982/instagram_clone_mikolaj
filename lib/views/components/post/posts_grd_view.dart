import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_thumbnail_view.dart';
import 'package:instagram_clone_mikolaj/views/post_comments/post_comments_view.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsGridView({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
          post: post,
          onTap: () {
            // debugPrint('Post tapped: $post');
            Navigator.push(
              context,
              // MaterialPageRoute(
              //   builder: (context) => PostDetailsView(
              //     post: post,
              //   ),
              // ),
              MaterialPageRoute(
                builder: (context) => PostCommentsView(
                  postId: post.postId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
