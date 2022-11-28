import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/comment.dart';
import 'package:instagram_clone_mikolaj/state/comments/models/post_comments_request.dart';

final specificPostWithCommentsProvider =
    StreamProvider.family.autoDispose<Iterable<Comment>, RequestForPostAndComments>((
  ref,
  RequestForPostAndComments request,
) {
  final controller = StreamController<Iterable<Comment>>();
  debugPrint('postId: ${request.postId}');

  final sub = FirebaseFirestore.instance
      .collection('comments')
      .where('post_id', isEqualTo: request.postId)
      .snapshots()
      .listen((snapshot) {
    final documents = snapshot.docs;
    final limitedDocuments = request.limit != null ? documents.take(request.limit!) : documents;
    final comments = limitedDocuments.where((doc) => !doc.metadata.hasPendingWrites).map(
          (doc) => Comment(
            id: doc.id,
            doc.data(),
          ),
        );

    final result = comments.applySortingFrom(request);
    debugPrint('number of comments: ${result.length}');
    controller.sink.add(result);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
