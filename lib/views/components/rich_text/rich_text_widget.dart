import 'dart:developer' as devtools show log;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/views/components/rich_text/base_text.dart';
import 'package:instagram_clone_mikolaj/views/components/rich_text/link_text.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class RichTextWidget extends StatelessWidget {
  // list or array of BaseText objects to render for this guy
  final Iterable<BaseText> texts;
  final TextStyle? styleForAll;

  const RichTextWidget({
    Key? key,
    required this.texts,
    this.styleForAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map((baseText) {
          if (baseText is LinkText) {
            // baseText was promoted to LinkText
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
              recognizer: TapGestureRecognizer()..onTap = baseText.onTap,
            );
          } else {
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
            );
          }
        }).toList(),
      ),
    );
  }
}
