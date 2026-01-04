import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/data/model/blog_modal.dart';

class SingleBlogView extends StatefulWidget {
  final BlogModal blogviewobj;
  const SingleBlogView({super.key, required this.blogviewobj});

  @override
  State<SingleBlogView> createState() => _SingleBlogViewState();
}

class _SingleBlogViewState extends State<SingleBlogView> {
  late BlogModal blogView;
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  
  @override
  void initState() {
    super.initState();
    blogView = widget.blogviewobj;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollProgress = (_scrollController.offset / 300).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Animated App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // actions: [
            //   Container(
            //     margin: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.9),
            //       shape: BoxShape.circle,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.1),
            //           blurRadius: 8,
            //         ),
            //       ],
            //     ),
            //     child: IconButton(
            //       icon: const Icon(Icons.bookmark_border, color: Colors.black87, size: 22),
            //       onPressed: () {},
            //     ),
            //   ),
            //   Container(
            //     margin: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.9),
            //       shape: BoxShape.circle,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.1),
            //           blurRadius: 8,
            //         ),
            //       ],
            //     ),
            //     child: IconButton(
            //       icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 22),
            //       onPressed: () {},
            //     ),
            //   ),
            // ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero Image
                  Image.file(
                    File(blogView.blogImage),
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Category and Title Overlay
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const CustomText(
                            text: 'TRAVEL',
                            color: Colors.white,
                            size: 11,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          text: blogView.blogTitle,
                          size: 28,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content Section
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  // Article Meta Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Travel Blogger',
                                size: 14,
                              ),
                              SizedBox(height: 2),
                              // CustomText(
                              //   text: '5 min read • Today',
                              //   size: 12,
                              //   color: Colors.grey,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade200,
                            Colors.grey.shade300,
                            Colors.grey.shade200,
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Article Content with Drop Cap Effect
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDropCapText(blogView.blogContent),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Featured Quote/Highlight (if content is long enough)
                  if (blogView.blogContent.length > 200)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          left: BorderSide(
                            color: Colors.blue,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.format_quote, color: Colors.blue.shade300, size: 30),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomText(
                              text: _extractQuote(blogView.blogContent),
                              size: 16,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 40),
                  
                  // Related Images Grid (Placeholder)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Gallery',
                          size: 22,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.file(
                                    File(blogView.blogImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      color: Colors.grey.shade400,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // // Engagement Section
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24),
                  //   child: Row(
                  //     children: [
                  //       _buildEngagementButton(Icons.favorite_border, '245'),
                  //       const SizedBox(width: 16),
                  //       _buildEngagementButton(Icons.mode_comment_outlined, '32'),
                  //       const Spacer(),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  //         decoration: BoxDecoration(
                  //           gradient: LinearGradient(
                  //             colors: [Colors.blue.shade400, Colors.blue.shade600],
                  //           ),
                  //           borderRadius: BorderRadius.circular(25),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.blue.withOpacity(0.3),
                  //               blurRadius: 12,
                  //               offset: const Offset(0, 4),
                  //             ),
                  //           ],
                  //         ),
                  //         child: const Row(
                  //           children: [
                  //             Icon(Icons.bookmark_border, color: Colors.white, size: 18),
                  //             SizedBox(width: 8),
                  //             CustomText(
                  //               text: 'Save',
                  //               color: Colors.white,
                  //               size: 14,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementButton(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          CustomText(
            text: count,
            size: 14,
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildDropCapText(String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    return CustomText(
      text: content,
      size: 17,
      color: Colors.grey.shade800,
    );
  }

  String _extractQuote(String content) {
    // Extract a meaningful quote from content (first 100 chars or first sentence)
    if (content.length > 100) {
      final firstSentence = content.split('.').first;
      return firstSentence.length < 150 ? '$firstSentence.' : '${content.substring(0, 100)}...';
    }
    return content;
  }
}