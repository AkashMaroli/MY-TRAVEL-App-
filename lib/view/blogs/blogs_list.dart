import 'package:flutter/material.dart';
import 'package:travelapp/core/services/blog_function.dart';
import 'package:travelapp/view/blogs/add_blog_screen.dart';
import 'package:travelapp/view/blogs/widget/blog_card.dart';
import 'package:travelapp/view/blogs/widget/blog_empty_widget.dart';
import 'package:travelapp/theme/app_color.dart';


class Blogslist extends StatefulWidget {
  const Blogslist({super.key});

  @override
  State<Blogslist> createState() => _BlogslistState();
}

class _BlogslistState extends State<Blogslist> {
  @override
  void initState() {
    super.initState();
    BlogDbFunc().allblog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.appPrimaryColor,
      automaticallyImplyLeading: false,
      title: const Text(
        'Travel Blogs',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       // Add filter/search functionality if needed
      //     },
      //     icon: const Icon(Icons.tune, color: Colors.white, size: 24),
      //   ),
      //   const SizedBox(width: 8),
      // ],
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: blogNotifier,
      builder: (BuildContext context, blogList, _) {
        if (blogList.isEmpty) {
          return const BlogEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await BlogDbFunc().allblog();
          },
          color: AppColor.appPrimaryColor,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 100),
            itemCount: blogList.length,
            itemBuilder: (context, index) {
              final blog = blogList[index];
              return BlogCard(
                blog: blog,
                onRefresh: () {
                  setState(() {});
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddBlogpage()),
        );
        setState(() {});
      },
      backgroundColor: AppColor.appPrimaryColor,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'New Blog',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

