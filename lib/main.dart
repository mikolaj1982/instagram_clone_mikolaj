import 'dart:developer' as devtools show log;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/state/auth/backend/authenticator.dart';

import 'firebase_options.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

// https://instagram-clone-mikolaj.firebaseapp.com/__/auth/handler

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Clone - Mikolaj'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              var status = await Authenticator.instance.loginWithGoogle();
              status.log();
            },
            child: const Text(
              'Sign In with Google',
            ),
          ),
          TextButton(
            onPressed: () async {
              var status = await Authenticator.instance.loginWithFacebook();
              status.log();
            },
            child: const Text(
              'Sign In with Facebook',
            ),
          )
        ],
      ),
    );
  }
}
