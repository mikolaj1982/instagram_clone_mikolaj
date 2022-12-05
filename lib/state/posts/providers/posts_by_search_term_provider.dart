import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:instagram_clone_mikolaj/views/tabs/search/search_view.dart';

final postsBySearchTermProvider =
    StreamProvider.family.autoDispose<Iterable<Post>, SearchTerm>((ref, SearchTerm searchTerm) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('created_at', descending: true)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs.map((doc) {
      return Post(
        json: doc.data(),
        postId: doc.id,
        createdAt:
            (doc.data()['created_at'] == null) ? DateTime.now() : (doc.data()['created_at'] as Timestamp).toDate(),
      );
    }).where((post) {
      // debugPrint('post: ${post.message} , searchTerm: $searchTerm');
      return post.message.toLowerCase().contains(
            searchTerm.toLowerCase(),
          );
    });

    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
