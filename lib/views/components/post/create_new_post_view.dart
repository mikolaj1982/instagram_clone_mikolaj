import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/thumbnail_request.dart';
import 'package:instagram_clone_mikolaj/state/posts/providers/providers.dart';
import 'package:instagram_clone_mikolaj/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/models/post_setting.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/components/post/file_thumbnail_view.dart';

// stateful consumer widget because of mounted property
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
    final postController = useTextEditingController(text: '');

    // useState available thanks to riverpod hooks it is stateful => StatefulHookConsumerWidget
    final isPostButtonEnabled = useState(false);
    useEffect(() {
      void listener() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listener);
      return () {
        postController.removeListener(listener);
      };
    }, [postController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isPostButtonEnabled.value
                ? () async {
                    final UserId? userId = ref.read(userIdProvider);
                    if (userId == null) {
                      return;
                    }

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
                  }
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FileThumbnailView(
                thumbnailRequest: thumbnailRequest,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: postController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    labelText: Strings.pleaseWriteYourMessageHere,
                  ),
                  autofocus: true,
                  maxLines: null,
                ),
              ),
              ...PostSetting.values.map(
                (PostSetting setting) => ListTile(
                  title: Text(setting.title),
                  subtitle: Text(setting.description),
                  trailing: Switch(
                    value: postSettings[setting] ?? false,
                    onChanged: (bool isOn) {
                      ref.read(postSettingsProvider.notifier).setSetting(setting, isOn);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
