import 'dart:async' show Completer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material show Image;

// usage final aspectRatio = await image.getAspectRatio();
extension GetImageAspectRatio on material.Image {
  Future<double> getAspectRatio() async {
    final Completer<double> completer = Completer<double>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image.width / info.image.height);
          info.image.dispose();
        },
      ),
    );
    return completer.future;
  }
}

extension GetImageDataAspectRatio on Uint8List {
  Future<double> getAspectRatio() async {
    final image = material.Image.memory(this);
    return image.getAspectRatio();
  }
}
