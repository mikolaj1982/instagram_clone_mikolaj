import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/models/auth_result.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';

import '../models/auth_state.dart';
import '../notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);

// one provider is for us to know whether you are logged in or not
final isLoggedInProvider = Provider<bool>((ref) {
  final AuthState authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});

// userId provider
final userIdProvider = Provider<UserId?>((ref) {
  final AuthState authState = ref.watch(authStateProvider);
  return authState.userId;
});

final isLoadingProvider = Provider<bool>((ref) {
  final AuthState authState = ref.watch(authStateProvider);
  return authState.isLoading;
});
