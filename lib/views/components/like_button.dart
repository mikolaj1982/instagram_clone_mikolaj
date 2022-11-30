import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/likes/models/like_dislike_request.dart';
import 'package:instagram_clone_mikolaj/state/likes/providers/has_liked_post_provider.dart';
import 'package:instagram_clone_mikolaj/state/likes/providers/like_dislike_post_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

import 'animations/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  final PostId postId;

  const LikeButton({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(hasLikedPostProvider(postId));

    return hasLiked.when(
      data: (hasLiked) {
        return IconButton(
          icon: FaIcon(
            hasLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
            color: hasLiked ? Colors.red : Colors.black,
          ),
          onPressed: () {
            final userId = ref.read(userIdProvider);
            if (userId == null) {
              return;
            }

            final likeRequest = LikeDislikeRequest(
              postId: postId,
              likedBy: userId,
            );

            ref.read(likeDislikePostProvider(
              likeRequest,
            ));
          },
        );
      },
      error: (error, _) => const SmallErrorAnimationView(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
