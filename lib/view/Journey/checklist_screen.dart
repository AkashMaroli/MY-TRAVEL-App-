import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';

class JourneyChecklistPage extends StatefulWidget {
  final Tripmodel checklistData;
  const JourneyChecklistPage({super.key, required this.checklistData});

  @override
  State<JourneyChecklistPage> createState() => _JourneyChecklistPageState();
}

class _JourneyChecklistPageState extends State<JourneyChecklistPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController checklistController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Tripmodel checklistFinalData;
  late int checklistKey;
  late AnimationController _animationController;

  final List<List<Color>> gradientColors = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFFf093fb), Color(0xFFf5576c)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
    [Color(0xFFfa709a), Color(0xFFfee140)],
    [Color(0xFF30cfd0), Color(0xFF330867)],
  ];

  @override
  void initState() {
    super.initState();
    checklistFinalData = widget.checklistData;
    checklistKey = checklistFinalData.key;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    checklistController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  int get completedCount =>
      checklistFinalData.checklistModal
          ?.where((item) => item.isChecked)
          .length ??
      0;

  int get totalCount => checklistFinalData.checklistModal?.length ?? 0;

  double get progress => totalCount > 0 ? completedCount / totalCount : 0;

  @override
  Widget build(BuildContext context) {
    final hasItems = checklistFinalData.checklistModal != null &&
        checklistFinalData.checklistModal!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: hasItems 
        ? SingleChildScrollView(
            child: Column(
              children: [
                _buildProgressHeader(),
                _buildAddItemSection(),
                _buildChecklistItemsScrollable(),
              ],
            ),
          )
        : Column(
            children: [
              _buildAddItemSection(),
              Expanded(
                child: _buildEmptyState(),
              ),
            ],
          ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.cyan.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
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
                      'Your Progress',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completedCount of $totalCount completed',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(4),
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
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: checklistController,
              focusNode: _focusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: 'Add new item...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon:
                    Icon(Icons.add_circle_outline, color: Colors.blue.shade400),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
              ],
              validator: (value) {
                if (value != null && value.length > 25) {
                  return 'Max 25 characters';
                }
                return null;
              },
              onFieldSubmitted: (value) => _addItem(),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.cyan.shade400],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _addItem,
              icon:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.cyan.shade50],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checklist_rounded,
                size: 80,
                color: Colors.blue.shade300,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Items Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding items to your checklist\nStay organized for your trip',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItemsScrollable() {
    return Column(
      children: List.generate(
        checklistFinalData.checklistModal!.length,
        (index) {
          final item = checklistFinalData.checklistModal![index];
          final gradient = gradientColors[index % gradientColors.length];

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: index == checklistFinalData.checklistModal!.length - 1 ? 20 : 12,
            ),
            child: Dismissible(
              key: Key(item.title! + index.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
              ),
              confirmDismiss: (direction) => _confirmDelete(item, index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: item.isChecked
                        ? gradient[0].withOpacity(0.3)
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: item.isChecked
                          ? gradient[0].withOpacity(0.2)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _toggleItem(item),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: item.isChecked
                                  ? LinearGradient(colors: gradient)
                                  : null,
                              color: item.isChecked ? null : Colors.grey[200],
                              shape: BoxShape.circle,
                              boxShadow: item.isChecked
                                  ? [
                                      BoxShadow(
                                        color: gradient[0].withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: item.isChecked
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.title!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: item.isChecked
                                    ? Colors.grey[400]
                                    : Colors.black87,
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _confirmDelete(item, index),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.grey[400],
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChecklistItems() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: checklistFinalData.checklistModal!.length,
      itemBuilder: (context, index) {
        final item = checklistFinalData.checklistModal![index];
        final gradient = gradientColors[index % gradientColors.length];

        return Dismissible(
          key: Key(item.title! + index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            child:
                const Icon(Icons.delete_outline, color: Colors.white, size: 28),
          ),
          confirmDismiss: (direction) => _confirmDelete(item, index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.isChecked
                    ? gradient[0].withOpacity(0.3)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: item.isChecked
                      ? gradient[0].withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _toggleItem(item),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: item.isChecked
                              ? LinearGradient(colors: gradient)
                              : null,
                          color: item.isChecked ? null : Colors.grey[200],
                          shape: BoxShape.circle,
                          boxShadow: item.isChecked
                              ? [
                                  BoxShadow(
                                    color: gradient[0].withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: item.isChecked
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.title!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: item.isChecked
                                ? Colors.grey[400]
                                : Colors.black87,
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(item, index),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.grey[400],
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addItem() {
    String checklistItem = checklistController.text.trim();
    if (checklistItem.isNotEmpty && checklistItem.length <= 25) {
      final checklistCarrier = ChecklistModal(
        title: checklistItem,
        isChecked: false,
      );

      setState(() {
        checklistFinalData.checklistModal == null
            ? checklistFinalData.checklistModal = [checklistCarrier]
            : checklistFinalData.checklistModal!.add(checklistCarrier);
        checklistController.clear();
      });

      Tripdb().addnearbyplaces(checklistFinalData, checklistKey);
      _focusNode.unfocus();
    }
  }

  void _toggleItem(ChecklistModal item) async {
    setState(() {
      item.isChecked = !item.isChecked;
    });
    await Tripdb().editDetails(checklistFinalData, checklistFinalData.key);
  }

  Future<bool?> _confirmDelete(ChecklistModal item, int index) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[400]),
            const SizedBox(width: 12),
            const Text('Delete Item'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              checklistFinalData.checklistModal!.removeAt(index);
              await Tripdb()
                  .editDetails(checklistFinalData, checklistFinalData.key);
              if (context.mounted) {
                Navigator.pop(context, true);
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
}