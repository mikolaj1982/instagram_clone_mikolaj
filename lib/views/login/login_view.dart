// when logged out
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/login/facebook_button.dart';
import 'package:instagram_clone_mikolaj/views/login/login_view_signup_links.dart';

import 'divider_with_margins.dart';
import 'google_button.dart';

class LoginView extends ConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 40,
            ),
            // header text
            Text(
              Strings.welcomeToAppName,
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(
                textStyle: Theme.of(context).textTheme.displaySmall,
                fontWeight: FontWeight.w700,
                shadows: <Shadow>[
                  const Shadow(
                    offset: Offset(4.0, 4.0),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const DividerWithMargins(),
            Text(
              Strings.logIntoYourAccount,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(height: 1.5),
            ),
            const SizedBox(
              height: 20,
            ),
            GoogleButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).loginWithGoogle();
              },
            ),
            const SizedBox(
              height: 4,
            ),
            FacebookButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).loginWithFacebook();
              },
            ),
            const DividerWithMargins(),
            const LoginSignUpLinks(),
          ],
        ),
      ),
    );
  }
}
