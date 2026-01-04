import 'package:flutter/material.dart';
import 'package:travelapp/theme/app_color.dart';

class MenuSection extends StatelessWidget {
  final List<MenuItem> items;

  const MenuSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[100],
          indent: 72,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          final isFirst = index == 0;
          final isLast = index == items.length - 1;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? const Radius.circular(16) : Radius.zero,
                topRight: isFirst ? const Radius.circular(16) : Radius.zero,
                bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
                bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.appPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColor.appPrimaryColor,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Title and Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// MenuItem model (should be in the main screen file)
class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
