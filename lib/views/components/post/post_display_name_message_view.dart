import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:instagram_clone_mikolaj/state/user_info/provider/user_info_model_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/rich_two_parts_text.dart';

class PostDisplayNameMessageView extends ConsumerWidget {
  final Post post;

  const PostDisplayNameMessageView({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(userInfoModelProvider(
      post.userId,
    ));

    return userInfoModel.when(
      data: (userInfoModel) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: RichTwoPartsText(
            leftPart: userInfoModel.displayName,
            rightPart: post.message,
          ),
        );
      },
      error: (error, _) => const SmallErrorAnimationView(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
