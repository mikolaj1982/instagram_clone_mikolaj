import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';

final canCurrentUserDeletePostProvider = StreamProvider.autoDispose.family<bool, Post>((
  ref,
  Post post,
) async* {
  final userId = ref.watch(userIdProvider);
  yield userId == post.userId;
});
