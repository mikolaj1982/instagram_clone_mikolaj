import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_mikolaj/state/posts_settings/models/post_setting.dart';

class PostSettingsNotifier extends StateNotifier<Map<PostSetting, bool>> {
  PostSettingsNotifier()
      : super(
          UnmodifiableMapView(
            {
              // by default all settings are set to true
              for (final setting in PostSetting.values) setting: true,
            },
          ),
        );

  void setSetting(PostSetting setting, bool value) {
    // get existing setting if is same as value return otherwise set new state value
    final existingValue = state[setting];
    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(
      // update the current key in existing map
      Map.from(state)..[setting] = value,
    );
  }
}
