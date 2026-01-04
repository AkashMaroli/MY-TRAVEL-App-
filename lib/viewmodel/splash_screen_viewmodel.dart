import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/view/Intro/create_profile_screen.dart';
import 'package:travelapp/view/Intro/home_pages_main.dart';
import 'package:travelapp/view/onboard/onboard_flow.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> decideNavigation(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = prefs.getBool('profile_created');
    final isOnboardingDone = prefs.getString('onBordingComplete');

    await Future.delayed(const Duration(seconds: 1));

    log('Login: $isLoggedIn | Onboarding: $isOnboardingDone');

    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
      );
    } else if (isOnboardingDone == 'true') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileCreateScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingFlow()),
      );
    }
  }
}
