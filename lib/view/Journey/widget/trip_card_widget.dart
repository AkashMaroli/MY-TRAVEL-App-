import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/view/Journey/journey_custom_main.dart';
import 'package:travelapp/view/Creater/trip_edit_page.dart';
import 'package:travelapp/theme/app_color.dart';

class TripCard extends StatelessWidget {
  final Tripmodel trip;
  final Function(dynamic) onDelete;
  final VoidCallback onRefresh;
  final bool showActions;

  const TripCard({
    super.key,
    required this.trip,
    required this.onDelete,
    required this.onRefresh,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final startDate = DateFormat('dd MMM yyyy').format(trip.startdate);
    final endDate = DateFormat('dd MMM yyyy').format(trip.enddate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JourneyCustomMain(modelobj: trip),
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
              // Image Section
              _buildImageSection(),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Actions Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trip.destination,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showActions) _buildActionsMenu(context),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Date Info
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      '$startDate - $endDate',
                    ),

                    const SizedBox(height: 8),

                    // Budget Info
                    _buildInfoRow(
                      Icons.account_balance_wallet_outlined,
                      '₹${trip.budget}',
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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        height: 180,
        color: Colors.grey[200],
        child: trip.image != null && trip.image!.isNotEmpty
            ? kIsWeb
                ? Image.network(
                    trip.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(),
                  )
                : Image.file(
                    File(trip.image!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(),
                  )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColor.appPrimaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.landscape_outlined,
          size: 64,
          color: AppColor.appPrimaryColor.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTripscrren(editTrip: trip),
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
              Text('Edit'),
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
          'Delete Trip',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this trip to ${trip.destination}?',
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
              onDelete(trip.key);
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
