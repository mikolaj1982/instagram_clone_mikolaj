import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_mikolaj/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/views/components/post/post_details_view.dart';

@immutable
class Like extends MapView<String, String> {
  Like({
    required DateTime date,
    required PostId postId,
    required UserId likedBy,
  }) : super(
          {
            // serialize the values to the map view
            FirebaseFieldName.postId: postId,
            FirebaseFieldName.userId: likedBy,
            FirebaseFieldName.date: date.toIso8601String(),
          },
        );
}
