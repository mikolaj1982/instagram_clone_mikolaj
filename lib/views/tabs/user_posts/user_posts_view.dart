import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/empty_contents_wth_text_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/components/post/posts_grd_view.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var posts = ref.watch(userPostsProvider);

    return RefreshIndicator(
      onRefresh: () {
        debugPrint('refresh posts');
        ref.refresh(userPostsProvider);
        return Future.delayed(
          const Duration(seconds: 1),
        );
      },
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(text: Strings.noPostsAvailable);
          } else {
            PostsGridView(posts: posts);
          }
          return Container();
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () => const LoadingAnimationView(),
      ),
    );
  }
}
