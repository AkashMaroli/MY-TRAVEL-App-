import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/view/Journey/checklist_screen.dart';
import 'package:travelapp/view/Journey/expence_list.dart';
import 'package:travelapp/view/Journey/nearby_places.dart';
import 'package:travelapp/view/Journey/notes.dart';
import 'package:travelapp/view/Journey/photo_collection.dart';

class JourneyCustomMain extends StatefulWidget {
  final Tripmodel modelobj;
  const JourneyCustomMain({required this.modelobj, super.key});

  @override
  State<JourneyCustomMain> createState() => _JourneyCustomMain();
}

class _JourneyCustomMain extends State<JourneyCustomMain>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Tripmodel onetrip;
  late final List _pages;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    onetrip = widget.modelobj;
    _pages = [
      NearbyPlaceaddPage(placeobj: onetrip),
      JourneyChecklistPage(checklistData: onetrip),
      JourneynotesPage(data: onetrip),
      JourneyPhotosPage(tripmodelobj: onetrip),
      ExpenceListPage(expenceobj: onetrip),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
    final daysRemaining =
        onetrip.startdate.difference(DateTime.now()).inDays + 1;

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 300),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade400,
                Colors.cyan.shade300,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      // const Spacer(),
                      // IconButton(
                      //   icon: const Icon(Icons.share_outlined, color: Colors.white, size: 22),
                      //   onPressed: () {},
                      // ),
                      // IconButton(
                      //   icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade400,
                                        Colors.cyan.shade300
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.flight_takeoff,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Trip to',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        onetrip.destination,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateCard(
                                    'Start',
                                    DateFormat('dd MMM')
                                        .format(onetrip.startdate),
                                    DateFormat('yyyy')
                                        .format(onetrip.startdate),
                                    Icons.calendar_today,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.arrow_forward,
                                      color: Colors.grey[400], size: 18),
                                ),
                                Expanded(
                                  child: _buildDateCard(
                                    'End',
                                    DateFormat('dd MMM')
                                        .format(onetrip.enddate),
                                    DateFormat('yyyy').format(onetrip.enddate),
                                    Icons.event_available,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                color: daysRemaining > 0
                                    ? Colors.orange.shade50
                                    : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    daysRemaining > 0
                                        ? Icons.access_time
                                        : Icons.check_circle_outline,
                                    color: daysRemaining > 0
                                        ? Colors.orange.shade700
                                        : Colors.green.shade700,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      daysRemaining > 0
                                          ? '$daysRemaining days remaining'
                                          : 'Trip completed',
                                      style: TextStyle(
                                        color: daysRemaining > 0
                                            ? Colors.orange.shade700
                                            : Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.map_outlined, 'Places', 0),
                _buildNavItem(Icons.checklist_rounded, 'Tasks', 1),
                _buildNavItem(Icons.description_outlined, 'Notes', 2),
                _buildNavItem(Icons.photo_library_outlined, 'Photos', 3),
                _buildNavItem(
                    Icons.account_balance_wallet_outlined, 'Budget', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(String label, String date, String year, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 16),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          Text(
            year,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.blue.shade400, Colors.cyan.shade300],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_scaffoldkey.currentState?.hasEndDrawer == true) {
      Navigator.pop(context);
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}
