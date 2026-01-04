import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/theme/app_color.dart';
import 'package:travelapp/view/widgets/text_field_widget.dart';

// ignore: must_be_immutable
class EditTripscrren extends StatefulWidget {
  Tripmodel editTrip;
  EditTripscrren({super.key, required this.editTrip});

  @override
  State<EditTripscrren> createState() => _EditTripscrrenState();
}

class _EditTripscrrenState extends State<EditTripscrren> {
  late TextEditingController destinationcontroller;
  late TextEditingController startdatecontroller;
  late TextEditingController enddatecontroller;
  late TextEditingController budgetcontroller;

  DateTime? startingdate;
  DateTime? endingdate;

  final formkey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    destinationcontroller =
        TextEditingController(text: widget.editTrip.destination);

    budgetcontroller =
        TextEditingController(text: widget.editTrip.budget.toString());

    startingdate = widget.editTrip.startdate;
    endingdate = widget.editTrip.enddate;

    startdatecontroller = TextEditingController(
        text: widget.editTrip.startdate.toString().split(" ")[0]);

    enddatecontroller = TextEditingController(
        text: widget.editTrip.enddate.toString().split(" ")[0]);

    if (widget.editTrip.image != null &&
        widget.editTrip.image!.isNotEmpty) {
      _image = File(widget.editTrip.image!);
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
        title: const Text(
          'Edit Your Trip',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              /// Header Image (same as Add screen)
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
                child: Center(
                  child: GestureDetector(
                    onTap: uploadImage,
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
                            ? kIsWeb
                                ? Image.network(_image!.path,
                                    fit: BoxFit.cover)
                                : Image.file(_image!,
                                    fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined,
                                      size: 50,
                                      color:
                                          AppColor.appPrimaryColor),
                                  const SizedBox(height: 10),
                                  const Text('Edit Trip Photo'),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              /// Form section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Details',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    /// Destination (same validation)
                    buildTextField(
                      label: 'Destination',
                      controller: destinationcontroller,
                      hint: 'Where are you going?',
                      icon: Icons.location_on,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter your destination';
                        }
                        if (value.trim().length < 5) {
                          return 'Address must be at least 5 characters';
                        }
                        final addressRegex =
                            RegExp(r'^[a-zA-Z0-9\s,.\-/#]+$');
                        if (!addressRegex
                            .hasMatch(value.trim())) {
                          return 'Please enter a valid destination';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Dates
                    Row(
                      children: const [
                        Text(
                          'Date - From & To',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text('*',
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColor.appImportentColor)),
                      ],
                    ),
                    const SizedBox(height: 8),

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

                    /// Budget (same validation)
                    buildTextField(
                      label: 'Trip budget',
                      controller: budgetcontroller,
                      hint: 'Budget (₹)',
                      icon:
                          Icons.account_balance_wallet,
                      keyboardType:
                          TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Please enter your budget';
                        }
                        final b =
                            int.tryParse(value);
                        if (b == null) {
                          return 'Please enter a valid budget';
                        }
                        if (b < 1 ||
                            b > 1000000000) {
                          return 'Please enter a valid budget (1-1000000000)';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    /// Save button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: donebuttonclicked,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColor.appPrimaryColor,
                          foregroundColor: Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Update Trip',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold),
                        ),
                      ),
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

  /// Date field UI
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
      autovalidateMode:
          AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
            Icon(icon, color: AppColor.appPrimaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Update trip
  donebuttonclicked() async {
    if (formkey.currentState!.validate()) {
      widget.editTrip.destination =
          destinationcontroller.text.trim();
      widget.editTrip.startdate =
          startingdate!;
      widget.editTrip.enddate =
          endingdate!;
      widget.editTrip.budget =
          int.parse(budgetcontroller.text.trim());
      widget.editTrip.image = _image?.path;

      await Tripdb()
          .editDetails(
              widget.editTrip, widget.editTrip.key)
          .then((value) =>
              Navigator.pop(context, true));
    }
  }

  /// Pick start date (can't exceed end date)
  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startingdate ?? now,
      firstDate: now,
      lastDate: endingdate ?? DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startingdate = picked;
        startdatecontroller.text =
            picked.toString().split(" ")[0];

        if (endingdate != null &&
            endingdate!.isBefore(picked)) {
          endingdate = null;
          enddatecontroller.clear();
        }
      });
    }
  }

  /// Pick end date (after start date)
  Future<void> _selectendDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          endingdate ?? startingdate ?? now,
      firstDate: startingdate ?? now,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        endingdate = picked;
        enddatecontroller.text =
            picked.toString().split(" ")[0];
      });
    }
  }

  /// Pick & crop image
  Future<void> uploadImage() async {
    final pickedFile =
        await _picker.pickImage(
            source: ImageSource.gallery);

    if (pickedFile == null) return;

    final croppedFile =
        await ImageCropper().cropImage(
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
