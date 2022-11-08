import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_mikolaj/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  final String? email;
  final String? displayName;
  final UserId userId;

  UserInfoPayload({
    required this.email,
    required this.displayName,
    required this.userId,
  }) : super(
          {
            // serialize the values to the map view
            FirebaseFieldName.email: email ?? '',
            FirebaseFieldName.displayName: displayName ?? '',
            FirebaseFieldName.userId: userId,
          },
        );
}
