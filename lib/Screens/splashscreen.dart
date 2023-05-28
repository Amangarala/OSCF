// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:project/Import/imports.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splashIconSize: double.maxFinite,
      splash: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/OSCF logo.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      nextScreen: SignupScreen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
