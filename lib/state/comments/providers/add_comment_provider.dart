import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/comments/notifiers/send_comments_notifier.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/image_upload_notifier.dart';

// adding comment to firebase
final sendCommentProvider = StateNotifierProvider<SendCommentNotifier, IsLoading>(
  (_) => SendCommentNotifier(),
);
