// sometimes you want to send a value to a provider, here is an object here it is give something back to me
// provider is gonna take in a thumbnail request and it's gonna return an image with aspect ratio
// family provider is a providers that takes in a parameter

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/exception/could_not_build_thumbnail_exception.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/extension/get_aspect_ratio.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/image_with_aspect_ratio.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/thumbnail_request.dart';
import 'package:instagram_clone_mikolaj/state/posts/models/post.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// FutureProvider.autoDispose.family<RETURN_VALUE, INPUT_VALUE>
final thumbnailProvider = FutureProvider.autoDispose.family<ImageWithAspectRatio, ThumbnailRequest>((
  ref,
  ThumbnailRequest request,
) async {
  final Image image;

  switch (request.type) {
    case FileType.image:
      image = Image.file(
        request.file,
        fit: BoxFit.fitHeight,
      );
      break;
    case FileType.video:
      final thumb = await VideoThumbnail.thumbnailData(
        video: request.file.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );
      if (thumb == null) {
        throw const CouldNotBuildThumbnailException();
      }
      image = Image.memory(
        thumb,
        fit: BoxFit.fitHeight,
      );
  }

  final aspectRatio = await image.getAspectRatio();
  return ImageWithAspectRatio(
    image: image,
    aspectRatio: aspectRatio,
  );
});

// is gonna get all posts from firebase by userId, provider all posts for that user
// stream provider gives the values continuously, autoDispose helped with garbage collection
final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();
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
            createdAt:
                (doc.data()['created_at'] == null) ? DateTime.now() : (doc.data()['created_at'] as Timestamp).toDate(),
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

final allPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance.collection('posts').snapshots().listen((snapshots) {
    final posts = snapshots.docs.map((doc) {
      // debugPrint(doc.data()['created_at'].toString());
      // debugPrint('-----------------------------------------');
      final p = Post(
        postId: doc.id,
        json: doc.data(),
        createdAt:
            (doc.data()['created_at'] == null) ? DateTime.now() : (doc.data()['created_at'] as Timestamp).toDate(),
      );
      return p;
    });

    // debugPrint('allPostsProvider: ${posts.length}');
    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
