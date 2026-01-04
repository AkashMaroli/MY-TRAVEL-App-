import 'package:flutter/material.dart';
import 'package:travelapp/view/blogs/blogs_list.dart';
import 'package:travelapp/view/Journey/all_journeys_screen.dart';
import 'package:travelapp/view/Profile/profile_screen.dart';
import 'package:travelapp/theme/app_color.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const MyJourneyScreen(),
    const Blogslist(),
    const ProfileScreen(),
  ];

  final List<NavigationItem> _navItems = [
    NavigationItem(
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      label: 'Journeys',
    ),
    NavigationItem(
      icon: Icons.article_outlined,
      selectedIcon: Icons.article,
      label: 'Blogs',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColor.appPrimaryColor,
            unselectedItemColor: Colors.grey[400],
            selectedFontSize: 13,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            items: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedIndex == index;
              
              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.appPrimaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    size: 26,
                  ),
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

/// Navigation item model
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

