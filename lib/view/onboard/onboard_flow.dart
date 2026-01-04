import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelapp/theme/app_color.dart';
import 'package:travelapp/view/Intro/create_profile_screen.dart';
import 'package:travelapp/view/onboard/onboard_helper.dart';
import 'package:travelapp/viewmodel/onboarding_viewmodel.dart';

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow({super.key});

  void _navigateToProfile(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileCreateScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, vm, _) {
          final size = MediaQuery.of(context).size;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  /// Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: () {
                          vm.setSharedPreference();
                          _navigateToProfile(context);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Pages
                  Expanded(
                    child: PageView.builder(
                      controller: vm.pageController,
                      onPageChanged: vm.onPageChanged,
                      itemCount: vm.pages.length,
                      itemBuilder: (context, index) {
                        return OnboardingPage(
                          data: vm.pages[index],
                          screenHeight: size.height,
                        );
                      },
                    ),
                  ),

                  /// Indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        vm.pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: vm.currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: vm.currentPage == index
                                ? AppColor.appPrimaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Bottom button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => vm.nextPage(() {
                          vm.setSharedPreference();
                          _navigateToProfile(context);
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.appPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          vm.isLastPage ? 'Launch' : 'Next',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
