import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/models/post_setting.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/image_upload_notifier.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/notifiers/post_settings_notifier.dart';

// post setting notifier
final postSettingsProvider = StateNotifierProvider<PostSettingsNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingsNotifier(),
);

final imageUploaderProvider = StateNotifierProvider<ImageUploadNotifier, IsLoading>(
  (ref) => ImageUploadNotifier(),
);
