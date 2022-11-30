import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';
import 'package:instagram_clone_mikolaj/state/user_info/provider/user_info_model_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/rich_two_parts_text.dart';

class CompactCommentTile extends ConsumerWidget {
  final Comment comment;

  const CompactCommentTile({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoModelProvider(
      comment.fromUserId,
    ));

    return userInfo.when(
      data: (userInfo) {
        return RichTwoPartsText(
          leftPart: userInfo.displayName,
          rightPart: comment.comment,
        );
      },
      error: (error, _) => const SmallErrorAnimationView(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
