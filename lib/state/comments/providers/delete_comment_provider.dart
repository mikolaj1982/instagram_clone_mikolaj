// post setting notifier
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/comments/notifiers/delete_comments_notifier.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/image_upload_notifier.dart';

final deleteCommentProvider = StateNotifierProvider<DeleteCommentStateNotifier, IsLoading>(
  (_) => DeleteCommentStateNotifier(),
);
