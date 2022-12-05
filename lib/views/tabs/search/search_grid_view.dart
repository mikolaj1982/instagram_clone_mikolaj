import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:instagram_clone_mikolaj/state/posts/providers/posts_by_search_term_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/data_not_found_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/tabs/search/posts_silver_grid_view.dart';
import 'package:instagram_clone_mikolaj/views/tabs/search/search_view.dart';

class SearchGridView extends ConsumerWidget {
  final SearchTerm searchTerm;

  const SearchGridView({Key? key, required this.searchTerm}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Iterable<Post>> searchedPosts = ref.watch(
      postsBySearchTermProvider(searchTerm),
    );

    return searchedPosts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(
            child: DataNotFoundAnimationView(),
          );
        } else {
          return PostsSliverGridView(
            posts: posts,
          );
        }
      },
      error: (error, stackTrace) {
        return const SliverToBoxAdapter(
          child: ErrorAnimationView(),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
