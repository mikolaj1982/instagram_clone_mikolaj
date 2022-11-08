import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:instagram_clone_mikolaj/state/constants/firebase_collectiion_name.dart';
import 'package:instagram_clone_mikolaj/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_mikolaj/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required String userId,
    required String email,
    required String displayName,
  }) async {
    try {
      // to ensure that the user info is saved only once we use the set method instead of add
      // first we check if the user info exists
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        // we already got this user's profile info so just save new email and display name not... uid stay the same
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email,
        });
        return true;
      }

      // if it's the new user we save the user info in firestore
      UserInfoPayload userInfoPayload = UserInfoPayload(
        email: email,
        displayName: displayName,
        userId: userId,
      );

      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .add(
            userInfoPayload,
          ); // I don't have to say toMap() because of the MapView class
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
