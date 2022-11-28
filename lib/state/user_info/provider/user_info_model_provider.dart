import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/state/user_info/models/user_info_model.dart';

// user info model provider, get user info regarding certain user doesn't have to be user
// currently logged in
final userInfoModelProvider = StreamProvider.autoDispose.family<UserInfoModel, UserId>((ref, userId) {
  final controller = StreamController<UserInfoModel>();

  final sub = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: userId)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final json = doc.data();
      final userInfoModel = UserInfoModel.fromJson(
        json,
        userId: userId,
      );
      debugPrint('userInfoModel: $userInfoModel');
      controller.add(userInfoModel);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
