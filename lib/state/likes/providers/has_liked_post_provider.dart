import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

final hasLikedPostProvider = StreamProvider.autoDispose.family<bool, PostId>((
  ref,
  PostId postId,
) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    return Stream<bool>.value(false);
  }

  final controller = StreamController<bool>();

  final sub = FirebaseFirestore.instance
      .collection('likes')
      .where('post_id', isEqualTo: postId)
      .where('user_id', isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      controller.add(true);
    } else {
      controller.add(false);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
