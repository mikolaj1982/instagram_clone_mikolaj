import 'package:flutter/foundation.dart' show immutable, VoidCallback;
import 'package:flutter/material.dart' show TextStyle, Colors, TextDecoration;
import 'package:instagram_clone_mikolaj/views/components/rich_text/link_text.dart';

// @immutable annotation is saying that every field in this class is final
// final keyword says that you cannot assign value to the property after it is initialized
@immutable
class BaseText {
  final String text;
  final TextStyle? style;

  const BaseText({required this.text, this.style});

  // factory keyword is used to create a constructor that doesn't always create a new instance of its class
  // factory constructor is used when you want to return an instance of a subclass from a method
  factory BaseText.plain({
    required String text,
    TextStyle? style = const TextStyle(),
  }) =>
      BaseText(text: text, style: style);

  // internally is creating a LinkText which is a subclass of BaseText, it is called class clustering, the ability for the super class to return an instance of a subclass in one of it's constructors
  factory BaseText.link({
    required String text,
    required VoidCallback onTap,
    TextStyle? style = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
  }) =>
      LinkText(
        text: text,
        style: style,
        onTap: onTap,
      );

  @override
  String toString() {
    return 'BaseText{text: $text, style: $style}';
  }
}
