import 'package:flutter/material.dart' show Color;

// convert 0x?????? or #?????? to Color
extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );
}

extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
      this,
      (
        String result,
        String pattern,
      ) =>
          result.replaceAll(pattern, ''));
}
