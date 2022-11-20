import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/image_with_aspect_ratio.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/thumbnail_request.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/providers/thumbail_provider.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_mikolaj/views/components/animations/small_error_animation_view.dart';

class FileThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;

  const FileThumbnailView({
    Key? key,
    required this.thumbnailRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = ref.watch(
      thumbnailProvider(thumbnailRequest),
    );

    return thumbnail.when(
      data: (ImageWithAspectRatio imageWithAspectRatio) {
        return AspectRatio(
          aspectRatio: imageWithAspectRatio.aspectRatio,
          child: imageWithAspectRatio.image,
        );
      },
      loading: () => const LoadingAnimationView(),
      error: (error, stack) => const SmallErrorAnimationView(),
    );
  }
}
