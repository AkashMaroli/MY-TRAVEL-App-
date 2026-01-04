import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/theme/app_color.dart';
import 'package:travelapp/view/widgets/snack_bar_custom.dart';
import 'package:travelapp/view/widgets/text_field_widget.dart';

class AddTripscrren extends StatefulWidget {
  const AddTripscrren({super.key});

  @override
  State<AddTripscrren> createState() => _AddTripscrrenState();
}

class _AddTripscrrenState extends State<AddTripscrren> {
  TextEditingController destinationcontroller = TextEditingController();
  TextEditingController startdatecontroller = TextEditingController();
  TextEditingController enddatecontroller = TextEditingController();
  TextEditingController budgetcontroller = TextEditingController();
  DateTime? startingdate;
  DateTime? endingdate;

  final formkey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

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
        title: const Text(
          'Plan Your Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              // Header Image Section with Gradient
              Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.appPrimaryColor,
                      AppColor.appPrimaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Image Upload Area
                    Center(
                      child: GestureDetector(
                        onTap: () => uploadImage(),
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 40,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _image != null
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      kIsWeb
                                          ? Image.network(
                                              _image!.path,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              _image!,
                                              fit: BoxFit.cover,
                                            ),
                                      // Edit overlay
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: AppColor.appPrimaryColor
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 50,
                                          color: AppColor.appPrimaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Add Trip Photo',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Tap to upload',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Destination Field
                    buildTextField(
                      label: 'Destination',
                      controller: destinationcontroller,
                      hint: 'Where are you going?',
                      icon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your destination';
                        }

                        if (value.trim().length < 5) {
                          return 'Address must be at least 5 characters';
                        }

                        final addressRegex = RegExp(
                          r'^[a-zA-Z0-9\s,.\-/#]+$',
                        );

                        if (!addressRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid destination';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Date - From & To',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '*',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.appImportentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Date Fields Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            controller: startdatecontroller,
                            hint: 'Start Date',
                            icon: Icons.calendar_today,
                            onTap: _selectDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDateField(
                            controller: enddatecontroller,
                            hint: 'End Date',
                            icon: Icons.event,
                            onTap: _selectendDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Budget Field
                    buildTextField(
                      label: 'Trip budget',
                      controller: budgetcontroller,
                      hint: 'Budget (₹)',
                      icon: Icons.account_balance_wallet,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your budget';
                        }
                        final age = int.tryParse(value);
                        if (age == null) {
                          return 'Please enter a valid budget';
                        }
                        if (age < 1 || age > 1000000000) {
                          return 'Please enter a valid budget (1-1000000000)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: donebuttonclicked,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.appPrimaryColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor:
                              AppColor.appPrimaryColor.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Save Trip',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String hint,
  //   required IconData icon,
  //   TextInputType? keyboardType,
  //   String? Function(String?)? validator,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     keyboardType: keyboardType,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     validator: validator,
  //     style: const TextStyle(fontSize: 16),
  //     decoration: InputDecoration(
  //       hintText: hint,
  //       hintStyle: TextStyle(color: Colors.grey[400]),
  //       prefixIcon: Icon(icon, color: AppColor.appPrimaryColor),
  //       filled: true,
  //       fillColor: Colors.white,
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: Colors.grey[300]!),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: Colors.grey[300]!),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: AppColor.appPrimaryColor, width: 2),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Colors.red),
  //       ),
  //       focusedErrorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: Colors.red, width: 2),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
        return null;
      },
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, color: AppColor.appPrimaryColor, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.appPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Future<void> donebuttonclicked() async {
    // 1️⃣ Trigger validators FIRST
    if (!formkey.currentState!.validate()) {
      return;
    }

    if (_image == null) {
     return  AppSnackBar.show(context,
          message: 'Image not added', type: SnackType.warning);
    }
    // 2️⃣ Now it is SAFE to read values
    final destination = destinationcontroller.text.trim();
    final budget = budgetcontroller.text.trim();

    // Extra safety (dates)
    if (startingdate == null || endingdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select trip dates')),
      );
      return;
    }

    final newtrip = Tripmodel(
      destination: destination,
      startdate: startingdate!,
      enddate: endingdate!,
      budget: int.parse(budget),
      image: _image?.path,
    );

    await Tripdb().addData(newtrip);

    if (!mounted) return;

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Trip Added',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColor.appPrimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: endingdate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.appPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startingdate = picked;
      setState(() {
        startdatecontroller.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectendDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startingdate ?? DateTime.now(),
      firstDate: startingdate ?? DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.appPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      endingdate = picked;
      setState(() {
        enddatecontroller.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
      ],
    );

    if (croppedFile == null) return;

    setState(() {
      _image = File(croppedFile.path);
    });
  }
}
