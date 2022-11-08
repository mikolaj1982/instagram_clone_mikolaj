import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/backend/authenticator.dart';
import 'package:instagram_clone_mikolaj/state/auth/models/auth_result.dart';
import 'package:instagram_clone_mikolaj/state/auth/models/auth_state.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/state/user_info/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.loggedOut()) {
    if (Authenticator.instance.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: Authenticator.instance.userId,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true); // start loading
    await Authenticator.instance.logOut(); // logout
    state = const AuthState.loggedOut(); // done
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true); // start loading
    final result = await Authenticator.instance.loginWithGoogle();
    final userId = Authenticator.instance.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }

    state = AuthState(
      result: result,
      isLoading: false,
      userId: Authenticator.instance.userId,
    ); // done
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(true); // start loading
    final result = await Authenticator.instance.loginWithFacebook();
    final userId = Authenticator.instance.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }

    state = AuthState(
      result: result,
      isLoading: false,
      userId: Authenticator.instance.userId,
    ); // done
  }

  Future<void> saveUserInfo({required UserId userId}) {
    return _userInfoStorage.saveUserInfo(
      userId: userId,
      email: Authenticator.instance.email!,
      displayName: Authenticator.instance.displayName!,
    );
  }
}
