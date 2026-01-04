import 'package:flutter/material.dart';
import 'package:travelapp/core/services/blog_function.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/view/Profile/widget/menu_section.dart';
import 'package:travelapp/view/Profile/widget/profile_header.dart';
import 'package:travelapp/view/Profile/widget/status_card.dart';
import 'package:travelapp/view/Profile/contact_details.dart';
import 'package:travelapp/view/Profile/privacy_policy.dart';
import 'package:travelapp/view/Profile/terms_and_services.dart';
import 'package:travelapp/theme/app_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Tripdb().getAll();
    await BlogDbFunc().allblog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar with gradient
          _buildSliverAppBar(),

          // Profile Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Header
                const ProfileHeader(),

                const SizedBox(height: 24),

                // Stats Section
                _buildStatsSection(),

                const SizedBox(height: 24),

                // Menu Sections
                _buildAccountSection(),

                const SizedBox(height: 16),

                // App Version
                _buildAppVersion(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 70,
      floating: false,
      pinned: true,
      backgroundColor: AppColor.appPrimaryColor,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.appPrimaryColor,
                AppColor.appPrimaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'My Journey',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  icon: Icons.flight_takeoff,
                  label: 'Trips',
                  valueNotifier: tripnotifier,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  icon: Icons.article,
                  label: 'Blogs',
                  valueNotifier: blogNotifier,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Account & Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          MenuSection(
            items: [ 
              MenuItem(
                icon: Icons.headset_mic_rounded,
                title: 'Contact Support',
                subtitle: 'Get help from our team',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactPage(),
                    ),
                  );
                },
              ),
              MenuItem(
                icon: Icons.lock_outline,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              MenuItem(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'Our terms and conditions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndServices(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Text(
            'Version 2.0.0',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
