import 'dart:developer' as devtools show log;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/loading/loading_screen.dart';

import 'firebase_options.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone - Mikolaj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Consumer(
        builder: (context, ref, child) {
          ref.listen<bool>(isLoadingProvider, (_, isLoading) {
            if (isLoading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
          });

          return const HomePage();
        },
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? userId = ref.watch(userIdProvider);
    final bool isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Clone - Mikolaj'),
        actions: [
          if (userId != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authStateProvider.notifier).logOut(),
            ),
        ],
      ),
      body: (isLoggedIn) ? const MainView() : const LoginView(),
    );
  }
}

// for when you are already logged in
class MainView extends ConsumerWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? userId = ref.watch(userIdProvider);
    return Center(
      child: Text('Welcome $userId'),
    );
  }
}

// when logged out
class LoginView extends ConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            ref.read(authStateProvider.notifier).loginWithGoogle();
          },
          child: const Text(
            'Sign In with Google',
          ),
        ),
        TextButton(
          onPressed: () {
            ref.read(authStateProvider.notifier).loginWithFacebook();
          },
          child: const Text(
            'Sign In with Facebook',
          ),
        ),

        TextButton(
          onPressed: () {
            ref.read(authStateProvider.notifier).showLoading();

            Future.delayed(const Duration(seconds: 3), () {
              LoadingScreen.instance().show(context: context, message: 'test...');

              Future.delayed(const Duration(seconds: 2), () {
                LoadingScreen.instance().show(context: context, message: 'pizdeczka...');
              });
            });
          },
          child: const Text(
            'show loader',
          ),
        ),
        //
      ],
    );
  }
}
