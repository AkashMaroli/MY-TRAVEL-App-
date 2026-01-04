import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/custom_buttons.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';

class NearbyPlaceaddPage extends StatefulWidget {
  final Tripmodel placeobj;
  const NearbyPlaceaddPage({super.key, required this.placeobj});

  @override
  State<NearbyPlaceaddPage> createState() => NearbyPlaceaddPageState();
}

class NearbyPlaceaddPageState extends State<NearbyPlaceaddPage>
    with SingleTickerProviderStateMixin {
  late Tripmodel placeobj1;
  final GlobalKey<FormState> placepageformkey = GlobalKey<FormState>();
  final TextEditingController placename = TextEditingController();
  final TextEditingController placedescription = TextEditingController();
  int _currentStep = 0;
  late AnimationController _listAnimationController;
 bool _journeyCompleted = false;

  @override
  void initState() {
    super.initState();
    placeobj1 = widget.placeobj;
    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    placename.dispose();
    placedescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final places = placeobj1.nearbyPlacemodal ?? [];

    if (_currentStep >= places.length && places.isNotEmpty) {
      _currentStep = places.length - 1;
    } else if (_currentStep < 0) {
      _currentStep = 0;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: places.isEmpty ? _buildEmptyState() : _buildPlacesList(places),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPlaceSheet,
        backgroundColor: Colors.blue.shade600,
        elevation: 4,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text(
          'Add Place',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.explore_outlined,
                size: 80,
                color: Colors.blue.shade300,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Places Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start building your journey by adding\nplaces you want to visit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList(List<NearbyPlacemodal> places) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.cyan.shade300],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.route,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Journey',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Explore these amazing places',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final place = places[index];
                final isActive = index == _currentStep;
                final isPast = index < _currentStep;

                return _buildPlaceCard(
                    place, index, isActive, isPast, places.length);
              },
              childCount: places.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildPlaceCard(NearbyPlacemodal place, int index, bool isActive,
      bool isPast, int totalPlaces) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isActive || isPast
                      ? LinearGradient(
                          colors: [Colors.blue.shade400, Colors.cyan.shade300],
                        )
                      : null,
                  color: isActive || isPast ? null : Colors.grey[300],
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isPast
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              if (index < totalPlaces - 1)
                Container(
                  width: 2,
                  height: 60,
                  color: isPast ? Colors.blue.shade300 : Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentStep = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? Colors.blue.shade300 : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isActive
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: isActive ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.placename,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      color: Colors.red[400]),
                                  const SizedBox(width: 12),
                                  const Text('Delete'),
                                ],
                              ),
                              onTap: () => _confirmDelete(place),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (place.description != null &&
                        place.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                place.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isActive) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (index > 0)
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _currentStep = index - 1;
                                });
                              },
                              icon: const Icon(Icons.arrow_back, size: 16),
                              label: const Text('Previous'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[600],
                              ),
                            ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (index < totalPlaces - 1) {
                                setState(() {
                                  _currentStep = index + 1;
                                });
                              } else {
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Journey complete! 🎉'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.arrow_forward, size: 16),
                            label: Text(
                                index < totalPlaces - 1 ? 'Next' : 'Complete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(NearbyPlacemodal place) {
    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange[400]),
              const SizedBox(width: 12),
              const Text('Delete Place'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this place from your journey?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                placeobj1.nearbyPlacemodal?.remove(place);
                await Tripdb().editDetails(placeobj1, placeobj1.key);
                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    });
  }

  void _showAddPlaceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: placepageformkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade400,
                                Colors.cyan.shade300
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add_location,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Place',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Expand your journey',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: placename,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Place Name',
                        hintText: 'Enter the place name',
                        prefixIcon: const Icon(Icons.location_on),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please add place name';
                        }

                        final text = value.trim();

                        if (text.length > 18) {
                          return 'Name cannot exceed 18 characters';
                        }

                        // Allow only letters, numbers and single spaces between words
                        final validPattern = RegExp(
                            r'^(?=.*[A-Za-z])[A-Za-z0-9]+( [A-Za-z0-9]+)*$');

                        if (!validPattern.hasMatch(text)) {
                          return 'Only letter or letters and numbers allowed';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: placedescription,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Tell us about this place',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Icon(Icons.description),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please add description';
                        }

                        final trimmedValue = value.trim();

                        // Must contain at least one alphabet
                        if (!RegExp(r'[a-zA-Z]').hasMatch(trimmedValue)) {
                          return 'Description must contain letters';
                        }

                        if (trimmedValue.length > 25) {
                          return 'Description cannot exceed 25 characters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              placename.clear();
                              placedescription.clear();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _bottomsheetaddbuttonclicked(placeobj1.key);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add Place',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      placename.clear();
      placedescription.clear();
    });
  }

  void _bottomsheetaddbuttonclicked(dynamic key) async {
    final placeName = placename.text.trim();
    final placeDetail = placedescription.text.trim();

    if (placepageformkey.currentState!.validate()) {
      if (placeName.isNotEmpty && placeDetail.isNotEmpty) {
        final newplace = NearbyPlacemodal(
          description: placeDetail,
          placename: placeName,
        );

        placeobj1.nearbyPlacemodal == null
            ? placeobj1.nearbyPlacemodal = [newplace]
            : placeobj1.nearbyPlacemodal!.add(newplace);

        await Tripdb().addnearbyplaces(placeobj1, key);

        if (mounted) {
          Navigator.pop(context);
          setState(() {});
        }
      }
    }
  }
}
