import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/core/services/blog_function.dart';
import 'package:travelapp/data/model/blog_modal.dart';
import 'package:travelapp/theme/app_color.dart';

class EditBlogpage extends StatefulWidget {
  final BlogModal editBlogObj;
  const EditBlogpage({super.key, required this.editBlogObj});

  @override
  State<EditBlogpage> createState() => _EditBlogpageState();
}

class _EditBlogpageState extends State<EditBlogpage> {
  final ImagePicker _picker = ImagePicker();
  GlobalKey<FormState> blogformkey = GlobalKey<FormState>();

  late TextEditingController blogTitle;
  late TextEditingController blogContent;

  XFile? imageObj;

  @override
  void initState() {
    super.initState();

    blogTitle =
        TextEditingController(text: widget.editBlogObj.blogTitle);
    blogContent =
        TextEditingController(text: widget.editBlogObj.blogContent);

    if (widget.editBlogObj.blogImage.isNotEmpty) {
      imageObj = XFile(widget.editBlogObj.blogImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.appPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Edit Blog Post',
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => blogUpdate(widget.editBlogObj.key),
              icon: const Icon(Icons.check, color: Colors.white, size: 20),
              label: const CustomText(
                text: 'Update',
                color: Colors.white,
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: blogformkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title section (same as Add)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.appPrimaryColor,
                      AppColor.appPrimaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      color: Colors.white70,
                      size: 32,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: blogTitle,
                      autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Your Blog Title...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        errorStyle: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please add title name';
                        }

                        final text = value.trim();

                        if (text.length > 18) {
                          return 'Name cannot exceed 18 characters';
                        }

                        final validPattern = RegExp(
                            r'^(?=.*[A-Za-z])[A-Za-z0-9]+( [A-Za-z0-9]+)*$');

                        if (!validPattern.hasMatch(text)) {
                          return 'Only letters or letters and numbers allowed';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),

              /// Content section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    /// Image picker
                    Row(
                      children: [
                        Icon(Icons.image_outlined,
                            color:
                                AppColor.appPrimaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Featured Image',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: uploadImage,
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.05),
                              blurRadius: 10,
                              offset:
                                  const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: imageObj != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius
                                            .circular(14),
                                    child: kIsWeb
                                        ? Image.network(
                                            imageObj!.path,
                                            width:
                                                double.infinity,
                                            height:
                                                double.infinity,
                                            fit: BoxFit
                                                .cover,
                                          )
                                        : Image.file(
                                            File(imageObj!
                                                .path),
                                            width:
                                                double.infinity,
                                            height:
                                                double.infinity,
                                            fit: BoxFit
                                                .cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding:
                                          const EdgeInsets
                                              .all(8),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .black54,
                                        borderRadius:
                                            BorderRadius
                                                .circular(20),
                                      ),
                                      child: const Row(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min,
                                        children: [
                                          Icon(Icons.edit,
                                              color: Colors
                                                  .white,
                                              size: 16),
                                          SizedBox(
                                              width: 4),
                                          Text(
                                            'Change',
                                            style: TextStyle(
                                                color:
                                                    Colors
                                                        .white,
                                                fontSize:
                                                    12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(20),
                                    decoration:
                                        BoxDecoration(
                                      color: AppColor
                                          .appPrimaryColor
                                          .withOpacity(
                                              0.1),
                                      shape:
                                          BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons
                                          .add_photo_alternate_outlined,
                                      size: 40,
                                      color: AppColor
                                          .appPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 12),
                                  const Text(
                                    'Change Cover Image',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Blog content editor
                    Row(
                      children: [
                        Icon(Icons.edit_note,
                            color:
                                AppColor.appPrimaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Blog Content',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 10,
                            offset:
                                const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: blogContent,
                        autovalidateMode:
                            AutovalidateMode
                                .onUserInteraction,
                        maxLines: 15,
                        minLines: 15,
                        style: const TextStyle(
                            fontSize: 16, height: 1.6),
                        decoration: InputDecoration(
                          hintText:
                              'Share your travel story...',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                            borderSide:
                                BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.all(20),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please write your blog content';
                          }
                          if (value.trim().length <
                              25) {
                            return 'Content must be at least 25 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageObj = pickedFile;
    });
  }

  blogUpdate(key) async {
    var title = blogTitle.text.trim();
    var content = blogContent.text.trim();
    var image = imageObj?.path;

    if (title.isNotEmpty &&
        content.isNotEmpty &&
        image != null) {
      if (blogformkey.currentState!.validate()) {
        final blogKit = BlogModal(
          blogTitle: title,
          blogImage: image,
          blogContent: content,
        );
        await BlogDbFunc().editBlog(key, blogKit);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Please fill all fields including image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
