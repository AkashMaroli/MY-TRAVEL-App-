import 'package:flutter/material.dart';
import 'package:travelapp/theme/app_color.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? imagePath;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              Container(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  imagePath ?? 'Asset/Image/Add notes-amico.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // Message
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Start planning your adventures',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Optional: Add trip button
              ElevatedButton.icon(
                onPressed: () {
                  // This could trigger the add trip action
                  // You can pass a callback if needed
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add Your First Trip',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
