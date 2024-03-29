import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_mikolaj/state/auth/models/auth_result.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  const AuthState.loggedOut()
      : result = null,
        isLoading = false,
        userId = null;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        userId: userId,
        isLoading: isLoading,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) || (result == other.result && isLoading == other.isLoading && userId == other.userId);

  @override
  int get hashCode => Object.hashAll([
        result,
        isLoading,
        userId,
      ]);
}
