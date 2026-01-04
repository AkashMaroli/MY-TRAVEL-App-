import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/data/model/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentPage = 0;

  final List<OnboardingPageData> pages = const [
    OnboardingPageData(
      imagePath: 'Asset/Image/Traveling-pana.png',
      title: "Let's Travel",
      description:
          'Embark on a journey of discovery with our sleek and user-friendly travel app, right at your fingertips.',
    ),
    OnboardingPageData(
      imagePath: 'Asset/Image/Around the world-amico.png',
      title: 'Destinations',
      description:
          'Choose your dream destination and let our travel app guide you.',
    ),
    OnboardingPageData(
      imagePath: 'Asset/Image/Fund-bro .png',
      title: 'Budget Plan',
      description:
          'Manage your expenses and stay on track throughout your journey.',
    ),
    OnboardingPageData(
      imagePath: 'Asset/Image/Traveling-rafiki.png',
      title: 'Start Planning',
      description:
          "Create your dream destinations and make memories that last forever.",
    ),
  ];

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  bool get isLastPage => currentPage == pages.length - 1;

  void nextPage(VoidCallback onFinish) {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      onFinish();
    }
  }
  Future<void> setSharedPreference() async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString('onBordingComplete', 'true');
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
