import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/core/services/userdb_functions.dart';
import 'package:travelapp/data/model/user_model.dart';
import 'package:travelapp/theme/app_color.dart';
import 'package:travelapp/view/Intro/home_pages_main.dart';
import 'package:travelapp/view/Profile/terms_and_services.dart';
import 'package:travelapp/view/widgets/text_field_widget.dart';

class ProfileCreateScreen extends StatefulWidget {
  final Usermodel? existingUser;

  const ProfileCreateScreen({
    super.key,
    this.existingUser,
  });

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  bool isChecked = false;
  bool isLoading = false;

  bool get isEditMode => widget.existingUser != null;

  @override
  void initState() {
    super.initState();

    // 🔹 Prefill data if edit mode
    if (isEditMode) {
      final user = widget.existingUser!;
      nameController.text = user.name;
      emailController.text = user.email;
      ageController.text = user.age;
      addressController.text = user.city;
      isChecked = true; // already accepted
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   foregroundColor: Colors.black,
      //   title: Text(
      //     isEditMode ? 'Edit Profile' : 'Create Profile',
      //   ),
      // ),  
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                Text(
                  isEditMode ? 'Update your details' : 'Welcome!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditMode
                      ? 'Make changes to your profile'
                      : 'Please fill in your details to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 40),

                // Name
                buildTextField(
                  controller: nameController,
                  label: 'Full Name',
                  hint: 'Enter your name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    final nameRegex =
                        RegExp(r'^[A-Z][a-zA-Z]*(?: [A-Z][a-zA-Z]*)*$');
                    if (!nameRegex.hasMatch(value.trim())) {
                      return 'name must start with a capital letter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email
                buildTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Address
                buildTextField(
                  controller: addressController,
                  label: 'City / Address',
                  hint: 'Enter your location',
                  icon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your address';
                    }

                    final address = value.trim();

                    if (address.length < 5) {
                      return 'Address must be at least 5 characters';
                    }

                    // ✅ must contain at least one letter
                    if (!RegExp(r'[a-zA-Z]').hasMatch(address)) {
                      return 'Address must contain letters';
                    }

                    // ✅ allowed characters only
                    final addressRegex = RegExp(r'^[a-zA-Z0-9\s,.\-/#]+$');
                    if (!addressRegex.hasMatch(address)) {
                      return 'Please enter a valid address';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Age
                buildTextField(
                  controller: ageController,
                  label: 'Age',
                  hint: 'Enter your age',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final age = int.tryParse(value ?? '');
                    if (age == null || age < 1 || age > 100) {
                      return 'Enter valid age (1–100)';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Terms (only show on create)
                if (!isEditMode) _termsAndConditions(),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.appPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isEditMode ? 'Update Profile' : 'Create Profile',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _termsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
          activeColor: AppColor.appPrimaryColor,
        ),
        const Text('I accept the '),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TermsAndServices()),
            );
          },
          child: Text(
            'terms & conditions',
            style: TextStyle(color: AppColor.appPrimaryColor),
          ),
        ),
      ],
    );
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isEditMode && !isChecked) {
      _showSnackBar('Accept terms and conditions', isError: true);
      return;
    }

    setState(() => isLoading = true);

    final user = Usermodel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      city: addressController.text.trim(),
      age: ageController.text.trim(),
    );

    if (isEditMode) {
      await Userdb.updateUser(user);
      Navigator.pop(context);
    } else {
      await Userdb().adduser(user);
      await _setSharedPreference();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> _setSharedPreference() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('profile_created', true);
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
