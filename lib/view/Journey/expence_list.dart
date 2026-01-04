import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelapp/custom_widgests/custom_buttons.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/view/Creater/trip_edit_page.dart';
import 'package:travelapp/theme/app_color.dart';

class ExpenceListPage extends StatefulWidget {
  final Tripmodel expenceobj;

  const ExpenceListPage({super.key, required this.expenceobj});

  @override
  State<ExpenceListPage> createState() => _ExpenceListPageState();
}

class _ExpenceListPageState extends State<ExpenceListPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late int selectedIndex;
  final GlobalKey<FormState> expformkey = GlobalKey<FormState>();
  final TextEditingController costController = TextEditingController();
  final TextEditingController costTitleController = TextEditingController();

  late Tripmodel tripexpobj;
  late AnimationController _animationController;
  double percentage = 0;
  int sum = 0;

  final List<List<Color>> gradientColors = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFFf093fb), Color(0xFFf5576c)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
    [Color(0xFFfa709a), Color(0xFFfee140)],
    [Color(0xFF30cfd0), Color(0xFF330867)],
  ];

  int _rebuildKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tripexpobj = widget.expenceobj;
    totalExpencrCalculator(tripexpobj);
    percetageFinder();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    costController.dispose();
    costTitleController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && mounted) {
      _rebuildKey++;

      // Refresh data reference and recalculate
      tripexpobj = widget.expenceobj;
      totalExpencrCalculator(tripexpobj);
      percetageFinder();

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

  bool get isOverBudget => sum >= tripexpobj.budget;
  int get remaining => tripexpobj.budget - sum;

  @override
  Widget build(BuildContext context) {
    final hasExpenses =
        tripexpobj.expenceModal != null && tripexpobj.expenceModal!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        key: ValueKey('expense_scroll_$_rebuildKey'),
        child: Column(
          children: [
            _buildBudgetCard(),
            const SizedBox(height: 20),
            if (hasExpenses) _buildExpensesList() else _buildEmptyState(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseSheet(),
        backgroundColor: AppColor.appPrimaryColor,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOverBudget ? AppColor.appGradients : AppColor.appGradients,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isOverBudget ? Colors.red : AppColor.appPrimaryShadecolor2)
                .withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isOverBudget
                      ? Icons.warning_amber
                      : Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOverBudget ? 'Over Budget!' : 'Budget Tracker',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${tripexpobj.budget}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditTripscrren(editTrip: tripexpobj),
                    ),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spent',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹$sum',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isOverBudget ? 'Over by' : 'Remaining',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${remaining.abs()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(percentage * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isOverBudget)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'EXCEEDED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentage > 1 ? 1 : percentage,
                        minHeight: 10,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOverBudget
                              ? Colors.white
                              : Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                  colors: [Colors.green.shade50, Colors.teal.shade50],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: Colors.green.shade300,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Expenses Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start tracking your travel expenses\nStay within your budget',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddExpenseSheet(),
              icon: const Icon(Icons.add),
              label: const Text('Add First Expense'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    return ValueListenableBuilder(
      valueListenable: expencenotifier,
      builder: (BuildContext context, list, _) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: tripexpobj.expenceModal?.length ?? 0,
          itemBuilder: (context, index) {
            final expense = tripexpobj.expenceModal![index];
            final gradient = gradientColors[index % gradientColors.length];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.appPrimaryColor,
                    AppColor.appPrimaryColor.withValues(alpha: .5)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.appPrimaryShadecolor2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showEditExpenseSheet(index),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.expenceTitle ?? 'Unnamed',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${expense.cost}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: const Color.fromARGB(
                                          255, 66, 245, 81)),
                                  const SizedBox(width: 12),
                                  const Text('Edit'),
                                ],
                              ),
                              onTap: () => Future.delayed(
                                Duration.zero,
                                () => _showEditExpenseSheet(index),
                              ),
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      color: Colors.red[400]),
                                  const SizedBox(width: 12),
                                  const Text('Delete'),
                                ],
                              ),
                              onTap: () => _confirmDelete(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddExpenseSheet() {
    costController.clear();
    costTitleController.clear();
    _showExpenseSheet(isEdit: false);
  }

  void _showEditExpenseSheet(int index) {
    costController.text = tripexpobj.expenceModal![index].cost!;
    costTitleController.text = tripexpobj.expenceModal![index].expenceTitle!;
    _showExpenseSheet(isEdit: true, index: index);
  }

  void _showExpenseSheet({required bool isEdit, int? index}) {
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
                key: expformkey,
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
                                Colors.green.shade400,
                                Colors.teal.shade300
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isEdit ? Icons.edit : Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Edit Expense' : 'New Expense',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Track your spending',
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
                      controller: costController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: 'Enter amount',
                        prefixIcon: const Icon(Icons.currency_rupee),
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
                          borderSide: BorderSide(
                              color: Colors.green.shade300, width: 2),
                        ),
                      ),
                      inputFormatters: [
                        // Allow only digits and dot
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),

                        // Allow only ONE dot
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if ('.'.allMatches(newValue.text).length > 1) {
                            return oldValue;
                          }
                          return newValue;
                        }),

                        // Prevent starting with 0
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.startsWith('0')) {
                            return oldValue;
                          }
                          return newValue;
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please add your amount';
                        }

                        final amount = double.tryParse(value);

                        if (amount == null) {
                          return 'Enter a valid number';
                        }

                        if (amount <= 0) {
                          return 'Amount must be greater than 0';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: costTitleController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'What did you spend on?',
                        prefixIcon: const Icon(Icons.description),
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
                          borderSide: BorderSide(
                              color: Colors.green.shade300, width: 2),
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
                            onPressed: () => Navigator.pop(context),
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
                              if (isEdit && index != null) {
                                expenceUpdate(tripexpobj.key, index);
                              } else {
                                expenceModalsheetAddButtonclick(tripexpobj.key);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isEdit ? 'Update' : 'Add Expense',
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
    );
  }

  void _confirmDelete(int index) {
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
              const Text('Delete Expense'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this expense?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                tripexpobj.expenceModal!.removeAt(index);
                await Tripdb().editDetails(tripexpobj, tripexpobj.key);
                await totalExpencrCalculator(tripexpobj);
                await percetageFinder();
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

  expenceModalsheetAddButtonclick(dynamic key) async {
    String costTitle = costTitleController.text.trim();
    String costAmount = costController.text.trim();

    if (expformkey.currentState!.validate()) {
      if (costTitle.isNotEmpty && costAmount.isNotEmpty) {
        final expCarrier =
            ExpenceModal(expenceTitle: costTitle, cost: costAmount);
        tripexpobj.expenceModal == null
            ? tripexpobj.expenceModal = [expCarrier]
            : tripexpobj.expenceModal!.add(expCarrier);

        Tripdb().addnearbyplaces(tripexpobj, key);
        await totalExpencrCalculator(tripexpobj);
        await percetageFinder();

        if (mounted) {
          Navigator.pop(context);
          setState(() {
            costController.clear();
            costTitleController.clear();
          });
        }
      }
    }
  }

  expenceUpdate(dynamic key, int index) async {
    String costTitle = costTitleController.text.trim();
    String costAmount = costController.text.trim();

    if (expformkey.currentState!.validate()) {
      if (costTitle.isNotEmpty && costAmount.isNotEmpty) {
        tripexpobj.expenceModal![index].expenceTitle = costTitle;
        tripexpobj.expenceModal![index].cost = costAmount;

        await Tripdb().editDetails(tripexpobj, key);
        await totalExpencrCalculator(tripexpobj);
        await percetageFinder();

        if (mounted) {
          Navigator.pop(context);
          setState(() {
            costController.clear();
            costTitleController.clear();
          });
        }
      }
    }
  }

  totalExpencrCalculator(Tripmodel trip) {
    int tempSum = 0;
    for (var element in trip.expenceModal ?? []) {
      tempSum += int.parse(element.cost!);
    }
    setState(() {
      sum = tempSum;
    });
  }

  percetageFinder() {
    double percentageTemp = sum / tripexpobj.budget;
    setState(() {
      percentage = percentageTemp;
    });
  }
}
