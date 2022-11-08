import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseCollectionName {
  static const likes = 'likes';
  static const comments = 'comments';
  static const thumbnails = 'thumbnails';
  static const posts = 'posts';
  static const users = 'users';

  // making constructor private to prevent instantiation
  const FirebaseCollectionName._();
}
