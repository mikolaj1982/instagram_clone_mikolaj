class CouldNotBuildThumbnailException implements Exception {
  final String message = 'Could not build thumbnail';

  const CouldNotBuildThumbnailException();
}

class CouldNotDecodeImageException implements Exception {
  final String message = 'Could not decode image';

  const CouldNotDecodeImageException();
}
