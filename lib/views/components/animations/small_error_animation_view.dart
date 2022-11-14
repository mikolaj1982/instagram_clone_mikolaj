import 'package:instagram_clone_mikolaj/views/components/animations/lottie_animation_view.dart';

import 'models/lottie_animation.dart';

class SmallErrorAnimationView extends LottieAnimationView {
  const SmallErrorAnimationView({super.key})
      : super(
          animation: LottieAnimation.smallError,
        );
}
