import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:instagram_clone_mikolaj/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';

@immutable
class UserInfoModel extends MapView<String, String?> {
  final String? email;
  final String displayName;
  final UserId userId;

  UserInfoModel({
    required this.email,
    required this.displayName,
    required this.userId,
  }) : super(
          {
            // serialize the values to the map view
            FirebaseFieldName.email: email,
            FirebaseFieldName.displayName: displayName,
            FirebaseFieldName.userId: userId,
          },
        );

  UserInfoModel.fromJson(Map<String, dynamic> json, {required UserId userId})
      : this(
          email: json[FirebaseFieldName.email],
          displayName: json[FirebaseFieldName.displayName] ?? '',
          userId: userId,
        );

  @override
  String toString() {
    return 'UserInfoModel {userId: $userId, email: $email, displayName: $displayName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          displayName == other.displayName &&
          email == other.email;

  @override
  int get hashCode => Object.hashAll([
        userId,
        displayName,
        email,
      ]);
}
