enum FileType {
  image,
  video,
}

extension CollectionName on FileType {
  String get collectionName {
    switch (this) {
      case FileType.image:
        return 'images';
      case FileType.video:
        return 'videos';
    }
  }
}
