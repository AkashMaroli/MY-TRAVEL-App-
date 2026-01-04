import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/core/services/blog_function.dart';
import 'package:travelapp/data/model/blog_modal.dart';
import 'package:travelapp/view/Creater/blog_edit_page.dart';
import 'package:travelapp/view/Journey/widget/trip_list_view.dart';
import 'package:travelapp/view/blogs/single_blog_view.dart';
import 'package:travelapp/theme/app_color.dart';

class BlogCard extends StatelessWidget {
  final BlogModal blog;
  final VoidCallback onRefresh;

  const BlogCard({
    super.key,
    required this.blog,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleBlogView(blogviewobj: blog),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with gradient overlay
              _buildImageSection(),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Actions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            blog.blogTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildActionsMenu(context),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Read more indicator
                    Row(
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 16,
                          color: AppColor.appPrimaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Read full review',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.appPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColor.appPrimaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Main Image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            height: 220,
            color: Colors.grey[200],
            child: blog.blogImage.isNotEmpty
                ? kIsWeb
                    ? Image.network(
                        blog.blogImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                      )
                    : Image.file(
                        File(blog.blogImage),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                      )
                : _buildPlaceholderImage(),
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Blog Badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.appPrimaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColor.appPrimaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Travel Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColor.appPrimaryColor.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 64,
              color: AppColor.appPrimaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No Image',
              style: TextStyle(
                color: AppColor.appPrimaryColor.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600], size: 22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditBlogpage(editBlogObj: blog),
            ),
          ).then((_) => onRefresh());
        } else if (value == 'delete') {
          _showDeleteDialog(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 12),
              Text('Edit Blog'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Blog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${blog.blogTitle}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              BlogDbFunc().deleteblog(blog.key);
              Navigator.pop(context);
              onRefresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

