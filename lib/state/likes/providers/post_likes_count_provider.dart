import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

final postLikesCountProvider = StreamProvider.autoDispose.family<int, PostId>(
  (
    ref,
    PostId postId,
  ) {
    //fetch the number of likes for a certain post
    final controller = StreamController<int>.broadcast();

    controller.onListen = () {
      // initial state
      controller.sink.add(0);
    };

    final sub = FirebaseFirestore.instance
        .collection('likes')
        .where('post_id', isEqualTo: postId)
        .snapshots()
        .listen((snapshot) {
      controller.sink.add(snapshot.docs.length);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
