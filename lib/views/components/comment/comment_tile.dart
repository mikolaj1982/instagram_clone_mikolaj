import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';
import 'package:instagram_clone_mikolaj/state/comments/providers/delete_comment_provider.dart';
import 'package:instagram_clone_mikolaj/state/user_info/provider/user_info_model_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/components/dialogs/logout_dialog.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;

  const CommentTile({
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
        final currentUserId = ref.read(userIdProvider);
        // if id of current user matches id of user that made the comment allow for deletion otherwise don't show delete button
        return ListTile(
          trailing: currentUserId == comment.fromUserId
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final shouldDeleteComment = await displayDeleteDialog(context);
                    if (shouldDeleteComment) {
                      await ref.read(deleteCommentProvider.notifier).deleteComment(
                            commentId: comment.id,
                          );
                    }
                  },
                )
              : null,
          title: Text(userInfo.displayName),
          subtitle: Text(comment.comment),
        );
      },
      error: (error, _) => const SmallErrorAnimationView(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObjectToDelete: Strings.comment).present(context).then(
            (value) => value ?? false,
          );
}
