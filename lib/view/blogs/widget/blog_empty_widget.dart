import 'package:flutter/material.dart';
import 'package:travelapp/view/Journey/widget/trip_list_view.dart';
import 'package:travelapp/view/blogs/add_blog_screen.dart';
import 'package:travelapp/theme/app_color.dart';

class BlogEmptyState extends StatelessWidget {
  const BlogEmptyState({super.key});

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
              // Illustration
              Container(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'Asset/Image/Add notes-amico.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'No Blogs Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                'Share your travel experiences and\ninspire others with your stories',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // CTA Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddBlogpage(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Write Your First Blog',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),

              const SizedBox(height: 24),

              // Tips section
              _buildTipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.appPrimaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.appPrimaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColor.appPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tips for Great Blogs',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Share authentic travel experiences'),
          _buildTipItem('Add beautiful photos from your trips'),
          _buildTipItem('Include helpful tips for travelers'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColor.appPrimaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

