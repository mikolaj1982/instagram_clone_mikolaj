import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/likes/providers/post_likes_count_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

import 'constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;

  const LikesCountView({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesCount = ref.watch(postLikesCountProvider(
      postId,
    ));

    return postLikesCount.when(
      data: (int likesCount) {
        final personOrPeople = likesCount == 1 ? Strings.person : Strings.people;
        final likesText = '$likesCount $personOrPeople ${Strings.likedThis}';
        return Text(likesText);
      },
      error: (error, _) => const SmallErrorAnimationView(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
