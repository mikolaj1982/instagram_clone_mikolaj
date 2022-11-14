import 'package:instagram_clone_mikolaj/views/components/animations/lottie_animation_view.dart';

import 'models/lottie_animation.dart';

class ErrorAnimationView extends LottieAnimationView {
  const ErrorAnimationView({super.key})
      : super(
          animation: LottieAnimation.error,
        );
}
