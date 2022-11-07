import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_mikolaj/state/auth/constants/constant.dart';
import 'package:instagram_clone_mikolaj/state/auth/models/auth_result.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';

class Authenticator {
  static final Authenticator _instance = Authenticator._();

  Authenticator._();

  static Authenticator get instance => _instance;

  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  bool get isAlreadyLoggedIn => userId != null;

  String get displayName => FirebaseAuth.instance.currentUser?.displayName ?? '';

  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.token;

    if (token == null) {
      // user has aborted the login
      return AuthResult.aborted;
    }

    // static method
    final oauthCredentials = FacebookAuthProvider.credential(token);

    try {
      await FirebaseAuth.instance.signInWithCredential(
        oauthCredentials,
      );

      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      final email = e.email;
      final credential = e.credential;

      // 'account-exists-with-different-credential'
      if (e.code == Constants.accountExistsWithDifferentCredential && email != null && credential != null) {
        final providers = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        // if you already with google email that you are trying to use here
        if (providers.contains(Constants.googleCom)) {
          await loginWithGoogle();
          FirebaseAuth.instance.currentUser?.linkWithCredential(
            credential,
          );
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        Constants.emailScope,
      ],
    );

    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      // user has aborted the login
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(
        oauthCredentials,
      );
      return AuthResult.success;
    } catch (e) {
      debugPrint(e.toString());
      return AuthResult.failure;
    }
  }
}
