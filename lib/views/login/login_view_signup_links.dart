import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/components/rich_text/base_text.dart';
import 'package:instagram_clone_mikolaj/views/components/rich_text/rich_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginSignUpLinks extends StatelessWidget {
  const LoginSignUpLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
      styleForAll: Theme.of(context).textTheme.subtitle1?.copyWith(height: 1.5),
      texts: [
        BaseText.plain(
          text: Strings.dontHaveAnAccount,
        ),
        BaseText.plain(
          text: Strings.signUpOn,
        ),
        BaseText.link(
            text: Strings.facebook,
            style: const TextStyle(
              color: Colors.blue,
            ),
            onTap: () {
              launchUrl(
                Uri.parse(
                  Strings.facebookSignupUrl,
                ),
              );
            }),
        BaseText.plain(
          text: Strings.orCreateAnAccountOn,
        ),
        BaseText.link(
            text: Strings.google,
            style: const TextStyle(
              color: Colors.blue,
            ),
            onTap: () {
              launchUrl(
                Uri.parse(
                  Strings.googleSignupUrl,
                ),
              );
            }),
      ],
    );
  }
}
