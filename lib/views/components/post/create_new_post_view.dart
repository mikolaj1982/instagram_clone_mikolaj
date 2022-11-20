import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/thumbnail_request.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/models/post_setting.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/image_upload_notifier.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/post_settings_notifier.dart';
import 'package:instagram_clone_mikolaj/views/components/post/file_thumbnail_view.dart';

// post setting notifier
final postSettingsProvider = StateNotifierProvider<PostSettingsNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingsNotifier(),
);

final imageUploaderProvider = StateNotifierProvider<ImageUploadNotifier, IsLoading>(
  (ref) => ImageUploadNotifier(),
);

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType type;

  const CreateNewPostView({
    Key? key,
    required this.fileToPost,
    required this.type,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      type: widget.type,
    );

    final postSettings = ref.watch(postSettingsProvider);
    final postController = useTextEditingController(text: 'initial text');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new post'),
        actions: [
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final userId = ref.read(userIdProvider);
                final message = postController.text;
                final isUploaded = await ref.read(imageUploaderProvider.notifier).upload(
                      file: widget.fileToPost,
                      type: widget.type,
                      userId: userId!,
                      message: message,
                      postSettings: postSettings,
                    );
                if (isUploaded && mounted) {
                  Navigator.of(context).pop();
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            TextField(
              controller: postController,
              decoration: const InputDecoration(
                hintText: 'Write a caption...',
              ),
            ),
            ...PostSetting.values.map(
              (setting) => CheckboxListTile(
                title: Text(setting.toString()),
                value: postSettings[setting] ?? false,
                onChanged: (value) {
                  // ref.read(postSettingsProvider.notifier).setSetting(
                  //       postSettings,
                  //       value,
                  //     );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
