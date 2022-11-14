import 'package:instagram_clone_mikolaj/views/components/animations/lottie_animation_view.dart';

import 'models/lottie_animation.dart';

class SignInAnimationView extends LottieAnimationView {
  const SignInAnimationView({super.key})
      : super(
          animation: LottieAnimation.signInOrSignUpAnimation,
        );
}
