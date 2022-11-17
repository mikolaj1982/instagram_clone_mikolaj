import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/models/auth_result.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';

import '../models/auth_state.dart';
import '../notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);

// one provider is for us to know whether you are logged in or not
final isLoggedInProvider = Provider<bool>((ref) {
  final AuthState authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});

// userId provider
final userIdProvider = Provider<UserId?>((ref) {
  final AuthState authState = ref.watch(authStateProvider);
  return authState.userId;
});

final isLoadingProvider = Provider<bool>((ref) {
  final AuthState authState = ref.watch(authStateProvider);
  return authState.isLoading;
});

// is gonna get all posts from firebase by userId, provider all posts for that user
// stream provider gives the values continuously, autoDispose helped with garbage collection
final userPostsProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  final controller = StreamController<List<Post>>();
  final userId = ref.watch(userIdProvider);
  final sub = FirebaseFirestore.instance
      .collection('posts')
      .orderBy(
        'created_at',
        descending: true,
      ) // newest first
      .where('uid', isEqualTo: userId) // this cause indexing
      .snapshots()
      .listen((snapshot) {
    final documents = snapshot.docs;
    final posts = documents
        .where((doc) => !doc.metadata.hasPendingWrites)
        .map(
          (doc) => Post(
            postId: doc.id,
            json: doc.data(),
          ),
        )
        .toList();

    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
