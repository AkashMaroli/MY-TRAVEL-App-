import 'package:flutter/material.dart';
import 'package:travelapp/theme/app_color.dart';

/// Reusable onboarding screen widget with standardized layout
class OnboardingScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final bool showSkipButton;
  final VoidCallback? onSkipPressed;

  const OnboardingScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.showSkipButton = true,
    this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at top right
            if (showSkipButton)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: onSkipPressed,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            
            // Main content with scroll
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Image section
                      Container(
                        height: size.height * 0.4,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom buttons section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Primary button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onPrimaryPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.appPrimaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        primaryButtonText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Secondary button (optional)
                  if (secondaryButtonText != null && onSecondaryPressed != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: onSecondaryPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          secondaryButtonText!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page indicator dots for onboarding flow
class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  final Color activeColor;
  final Color inactiveColor;

  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.pageCount,
    this.activeColor = AppColor.appPrimaryColor,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}