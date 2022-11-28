import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone_mikolaj/state/comments/providers/add_comment_provider.dart';
import 'package:instagram_clone_mikolaj/state/comments/providers/post_comments_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/empty_contents_wth_text_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/comment/comment_tile.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

class PostCommentsView extends HookConsumerWidget {
  final PostId postId;

  const PostCommentsView({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController(text: '');

    final request = RequestForPostAndComments(
      postId: postId,
    );

    final AsyncValue<Iterable<Comment>> comments = ref.watch(
      specificPostWithCommentsProvider(
        request,
      ),
    );

    // enable Post button when text is entered in the comment text field
    // useState available thanks to riverpod hooks it is stateful => StatefulHookConsumerWidget
    final hasText = useState(false);
    useEffect(() {
      void listener() {
        hasText.value = commentController.text.isNotEmpty;
      }

      commentController.addListener(listener);
      return () {
        commentController.removeListener(listener);
      };
    }, [commentController]);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.comments,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: hasText.value
                  ? () {
                      _submitCommentWithController(
                        commentController,
                        ref,
                      );
                    }
                  : null,
            ),
          ],
        ),
        body: SafeArea(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 4,
                child: comments.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const SingleChildScrollView(
                        child: EmptyContentsWithTextAnimationView(
                          text: Strings.noCommentsYet,
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () {
                        ref.refresh(
                          specificPostWithCommentsProvider(request),
                        );
                        return Future.delayed(
                          const Duration(seconds: 1),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments.elementAt(index);
                          return CommentTile(
                            comment: comment,
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const LoadingAnimationView(),
                  error: (error, stack) => const SmallErrorAnimationView(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.send, // button on the keyboard needs to be named "send"
                            controller: commentController,
                            onChanged: (value) {
                              hasText.value = value.isNotEmpty;
                            },
                            onSubmitted: (comment) {
                              if (comment.isNotEmpty) {
                                _submitCommentWithController(
                                  commentController,
                                  ref,
                                );
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: Strings.writeYourCommentHere,
                              border: OutlineInputBorder(),
                              hintText: 'Add comment',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    // ref.read() get a snapshot of the providers data
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          commentedOnPostId: postId,
          comment: controller.text,
          fromUserId: userId,
        );

    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }
}

extension DismissKeyboard on Widget {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
