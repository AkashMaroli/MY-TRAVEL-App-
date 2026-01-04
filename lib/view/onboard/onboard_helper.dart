
import 'package:flutter/material.dart';
import 'package:travelapp/data/model/onboarding_model.dart';

/// Individual onboarding page widget
class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final double screenHeight;

  const OnboardingPage({
    required this.data,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Image
            Container(
              height: screenHeight * 0.4,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              data.description,
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
    );
  }
}