import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelapp/custom_widgests/custom_buttons.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:hive/hive.dart';
import 'package:travelapp/view/Journey/single_picview.dart';
import 'package:travelapp/view/Journey/widget/trip_list_view.dart';
import 'package:travelapp/theme/app_color.dart';

class JourneyPhotosPage extends StatefulWidget {
  final Tripmodel tripmodelobj;
  const JourneyPhotosPage({required this.tripmodelobj, Key? key})
      : super(key: key);

  @override
  State<JourneyPhotosPage> createState() => _JourneyPhotosPageState();
}

class _JourneyPhotosPageState extends State<JourneyPhotosPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Tripmodel tripmodelobj;
  final ImagePicker imagemultipicker = ImagePicker();
  late Box<Tripmodel> tripBox;
  late AnimationController _animationController;
  bool _isUploading = false;

  int _rebuildKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tripmodelobj = widget.tripmodelobj;
    tripmodelobj.photosModal ??= [];
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && mounted) {
      _rebuildKey++;

      // Refresh data reference
      tripmodelobj = widget.tripmodelobj;

      // Restart animation if needed
      if (_animationController.status == AnimationStatus.completed ||
          _animationController.status == AnimationStatus.dismissed) {
        _animationController.reset();
        _animationController.forward();
      }

      // Force rebuild to refresh layout constraints
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhotos = tripmodelobj.photosModal != null &&
        tripmodelobj.photosModal!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(hasPhotos),
          Expanded(
            child: hasPhotos ? _buildPhotoGrid() : _buildEmptyState(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            _isUploading ? null : () => uploadmultiphotos(tripmodelobj.key),
        backgroundColor: _isUploading ? Colors.grey : Colors.blue.shade600,
        elevation: 4,
        icon: _isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add_photo_alternate, color: Colors.white),
        label: Text(
          _isUploading ? 'Uploading...' : 'Add Photos',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool hasPhotos) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade400,
            Colors.cyan.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Photo Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasPhotos
                      ? '${tripmodelobj.photosModal!.length} ${tripmodelobj.photosModal!.length == 1 ? 'photo' : 'photos'}'
                      : 'No photos yet',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (hasPhotos)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${tripmodelobj.photosModal!.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.appPrimaryShadecolor,
                    AppColor.appPrimaryShadecolor2
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo,
                size: 60,
                color: AppColor.appPrimaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Photos Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Capture and save your travel memories\nStart building your photo collection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // ElevatedButton.icon(
            //   onPressed: () => uploadmultiphotos(tripmodelobj.key),
            //   icon: const Icon(Icons.add_photo_alternate),
            //   label: const Text('Upload Photos'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColor.appPrimaryColor,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(16),
            //     ),
            //     elevation: 2,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return ValueListenableBuilder(
      valueListenable: imageNotifier,
      builder: (BuildContext context, list, _) {
        return GridView.builder(
          key: ValueKey('photo_grid_$_rebuildKey'),
          padding: const EdgeInsets.all(20),
          itemCount: tripmodelobj.photosModal?.length ?? 0,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return _buildPhotoCard(index);
          },
        );
      },
    );
  }

  Widget _buildPhotoCard(int index) {
    final image = tripmodelobj.photosModal?[index].image;

    return Hero(
      tag: 'photo_$index',
      child: GestureDetector(
        onTap: kIsWeb
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SinglePicViewScreen(
                      picviewobj: tripmodelobj,
                      selectedIndex: index,
                    ),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: kIsWeb
                    ? Image.network(
                        image!,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(image!),
                        fit: BoxFit.cover,
                      ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              // Delete button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.white, size: 20),
                    onPressed: () => _confirmDeletePhoto(index),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              // Photo number
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.image, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeletePhoto(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[400]),
            const SizedBox(width: 12),
            const Text('Delete Photo'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this photo?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              tripmodelobj.photosModal!.removeAt(index);
              await Tripdb().editDetails(tripmodelobj, tripmodelobj.key);
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
  }

  uploadmultiphotos(var key) async {
    setState(() {
      _isUploading = true;
    });

    try {
      var pickedfiles = await imagemultipicker.pickMultiImage();

      if (pickedfiles.isNotEmpty) {
        log(pickedfiles.length);
        List<String> images = [];

        for (var element in pickedfiles) {
          images.add(element.path);
        }

        for (var element in images) {
          final photo = PhotosModal(image: element);
          tripmodelobj.photosModal == null
              ? tripmodelobj.photosModal = [photo]
              : tripmodelobj.photosModal?.add(photo);

          await Tripdb().addnearbyplaces(tripmodelobj, key).then((value) {
            imageNotifier.value.add(photo);
            imageNotifier.notifyListeners();
          });
        }

        setState(() {});

        try {
          await tripmodelobj.save();
        } catch (e) {
          print("Error saving tripmodel: $e");
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${images.length} ${images.length == 1 ? 'photo' : 'photos'} added successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to upload photos'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
