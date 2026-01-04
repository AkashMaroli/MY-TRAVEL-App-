import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/search_delegate.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/view/Intro/trips_add_screen.dart';
import 'package:travelapp/view/Journey/widget/empty_state_widget.dart';
import 'package:travelapp/view/Journey/widget/trip_list_view.dart';
import 'package:travelapp/theme/app_color.dart';

class MyJourneyScreen extends StatefulWidget {
  final String? query;
  const MyJourneyScreen({super.key, this.query});

  @override
  State<MyJourneyScreen> createState() => _MyJourneyScreenState();
}

class _MyJourneyScreenState extends State<MyJourneyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String searchQuery;

  List<Tripmodel> ongoingTrips = [];
  List<Tripmodel> completedTrips = [];

  @override
  void initState() {
    super.initState();
    searchQuery = widget.query ?? '';
    _tabController = TabController(length: 3, vsync: this);
    _fetchAndFilterTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndFilterTrips() async {
    await Tripdb().getAll();
    _filterTrips();
  }

  void _filterTrips() {
    final now = DateTime.now();
    final allTrips = tripnotifier.value;

    setState(() {
      completedTrips =
          allTrips.where((trip) => trip.enddate.isBefore(now)).toList();
      ongoingTrips =
          allTrips.where((trip) => trip.startdate.isAfter(now)).toList();
    });
  }

  Future<void> _deleteTrip(dynamic key) async {
    await Tripdb().deletetrip(key);
    if (mounted) {
      Navigator.pop(context);
      _filterTrips();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.appPrimaryColor,
      automaticallyImplyLeading: false,
      title: const Text(
        'Destinoz',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
          icon: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 8),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'All Trips'),
          Tab(text: 'Ongoing'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        // All Trips Tab
        ValueListenableBuilder(
          valueListenable: tripnotifier,
          builder: (context, List<Tripmodel> trips, _) {
            final filteredTrips = searchQuery.isEmpty
                ? trips
                : trips
                    .where((trip) => trip.destination
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

            if (filteredTrips.isEmpty) {
              return const EmptyStateWidget(
                message: 'No trips added yet',
              );
            }

            return TripListView(
              trips: filteredTrips,
              onDelete: _deleteTrip,
              onRefresh: _filterTrips,
            );
          },
        ),

        // Ongoing Trips Tab
        ValueListenableBuilder(
          valueListenable: tripnotifier,
          builder: (context, _, __) {
            if (ongoingTrips.isEmpty) {
              return const EmptyStateWidget(
                message: 'No ongoing trips',
              );
            }

            return TripListView(
              trips: ongoingTrips,
              onDelete: _deleteTrip,
              onRefresh: _filterTrips,
              showActions: false,
            );
          },
        ),

        // Completed Trips Tab
        ValueListenableBuilder(
          valueListenable: tripnotifier,
          builder: (context, _, __) {
            if (completedTrips.isEmpty) {
              return const EmptyStateWidget(
                message: 'No completed trips',
              );
            }

            return TripListView(
              trips: completedTrips,
              onDelete: _deleteTrip,
              onRefresh: _filterTrips,
              showActions: false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTripscrren()),
        );
        _filterTrips();
      },
      backgroundColor: AppColor.appPrimaryColor,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Add Trip',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
