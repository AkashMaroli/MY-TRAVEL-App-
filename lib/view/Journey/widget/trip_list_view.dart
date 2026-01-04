import 'package:flutter/material.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/view/Journey/widget/trip_card_widget.dart';
import 'package:travelapp/theme/app_color.dart';

class TripListView extends StatelessWidget {
  final List<Tripmodel> trips;
  final Function(dynamic) onDelete;
  final VoidCallback onRefresh;
  final bool showActions;

  const TripListView({
    super.key,
    required this.trips,
    required this.onDelete,
    required this.onRefresh,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      color: AppColor.appPrimaryColor,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 12, bottom: 100),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return TripCard(
            trip: trips[index],
            onDelete: onDelete,
            onRefresh: onRefresh,
            showActions: showActions,
          );
        },
      ),
    );
  }
}

