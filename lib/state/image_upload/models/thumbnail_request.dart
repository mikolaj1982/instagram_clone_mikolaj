import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';

@immutable
class ThumbnailRequest {
  final File file;
  final FileType type;

  const ThumbnailRequest({
    required this.file,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailRequest && runtimeType == other.runtimeType && file == other.file && type == other.type;

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        file,
        type,
      ]);
}
