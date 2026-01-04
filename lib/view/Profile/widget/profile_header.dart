import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelapp/core/services/userdb_functions.dart';
import 'package:travelapp/data/model/user_model.dart';
import 'package:travelapp/theme/app_color.dart';
import 'package:travelapp/view/Intro/create_profile_screen.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    Userdb.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Usermodel?>(
      valueListenable: usernotifier,
      builder: (context, user, _) {
        final userName = user?.name ?? 'User';
        final userEmail = user?.email ?? '';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  _avatar(user),
                  const SizedBox(width: 20),
                  _userInfo(userName, userEmail),
                ],
              ),
              // Edit button in top right
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColor.appPrimaryColor,
                    size: 20,
                  ),
                  onPressed: () => _openEditProfile(user),
                  tooltip: 'Edit Profile',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- Avatar ----------------
  Widget _avatar(Usermodel? user) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.appPrimaryColor,
                AppColor.appPrimaryColor.withOpacity(0.7),
              ],
            ),
          ),
          child: _image != null
              ? ClipOval(
                  child: Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
        ),

        // // 📷 Camera button for changing profile picture
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: GestureDetector(
        //     onTap: _pickImage,
        //     child: Container(
        //       padding: const EdgeInsets.all(6),
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         shape: BoxShape.circle,
        //         border: Border.all(color: Colors.grey.shade300),
        //       ),
        //       child: Icon(
        //         Icons.camera_alt,
        //         size: 14,
        //         color: AppColor.appPrimaryColor,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // ---------------- User Info ----------------
  Widget _userInfo(String name, String email) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  // ---------------- Navigation ----------------
  void _openEditProfile(Usermodel? user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileCreateScreen(
          existingUser: user,
        ),
      ),
    );
  }

  // ---------------- Image Picker ----------------
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = picked;
      });
    }
  }
}