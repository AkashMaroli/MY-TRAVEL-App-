import 'package:flutter/material.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';
import 'package:travelapp/theme/app_color.dart';

class JourneynotesPage extends StatefulWidget {
  final Tripmodel data;
  const JourneynotesPage({super.key, required this.data});

  @override
  State<JourneynotesPage> createState() => _JourneynotesPageState();
}

class _JourneynotesPageState extends State<JourneynotesPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Tripmodel notesDatas;
  final TextEditingController noteHead = TextEditingController();
  final TextEditingController noteDescription = TextEditingController();
  final GlobalKey<FormState> noteFormKey = GlobalKey<FormState>();
  late AnimationController _animationController;

  final List<List<Color>> gradientColors = [
    [Color(0xFFff9a9e), Color(0xFFfad0c4)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFFffecd2), Color(0xFFfcb69f)],
    [Color(0xFFff6e7f), Color(0xFFbfe9ff)],
    [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
    [Color(0xFFfbc7d4), Color(0xFF9796f0)],
  ];

  int _rebuildKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notesDatas = widget.data;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    noteHead.dispose();
    noteDescription.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && mounted) {
      _rebuildKey++;

      // Refresh data reference
      notesDatas = widget.data;

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
    final hasNotes =
        notesDatas.notesModal != null && notesDatas.notesModal!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: hasNotes ? _buildNotesList() : _buildEmptyState(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNoteSheet,
        backgroundColor: Colors.blue.shade600,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Note',
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
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
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
                Icons.note_add_outlined,
                size: 80,
                color: AppColor.appPrimaryColor,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Notes Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Capture your travel memories\nand important information',
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

  Widget _buildNotesList() {
    return CustomScrollView(
      key: ValueKey('notes_scroll_$_rebuildKey'),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.pink.shade300],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Travel Notes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${notesDatas.notesModal!.length} ${notesDatas.notesModal!.length == 1 ? 'note' : 'notes'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final note = notesDatas.notesModal![index];
                final gradient = gradientColors[index % gradientColors.length];

                return _buildNoteCard(note, index, gradient);
              },
              childCount: notesDatas.notesModal!.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildNoteCard(NotesModal note, int index, List<Color> gradient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title ?? 'Untitled',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Colors.blue[400]),
                            const SizedBox(width: 12),
                            const Text('Edit'),
                          ],
                        ),
                        onTap: () => Future.delayed(
                          Duration.zero,
                          () => _editNote(note, index),
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red[400]),
                            const SizedBox(width: 12),
                            const Text('Delete'),
                          ],
                        ),
                        onTap: () => _confirmDelete(note, index),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  note.description ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showNoteDetails(NotesModal note, List<Color> gradient) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: MediaQuery.of(context).size.height * 0.7,
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: gradient,
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ),
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(28),
  //           topRight: Radius.circular(28),
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           Container(
  //             margin: const EdgeInsets.only(top: 12),
  //             width: 50,
  //             height: 5,
  //             decoration: BoxDecoration(
  //               color: Colors.white.withOpacity(0.5),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //           Expanded(
  //             child: SingleChildScrollView(
  //               padding: const EdgeInsets.all(24),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     note.title ?? 'Untitled',
  //                     style: const TextStyle(
  //                       fontSize: 28,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Container(
  //                     padding: const EdgeInsets.all(20),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white.withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(16),
  //                     ),
  //                     child: Text(
  //                       note.description ?? '',
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         color: Colors.white,
  //                         height: 1.6,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showAddNoteSheet() {
    noteHead.clear();
    noteDescription.clear();

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
                key: noteFormKey,
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
                                Colors.purple.shade400,
                                Colors.pink.shade300
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.note_add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Note',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Capture your thoughts',
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
                      controller: noteHead,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter note title',
                        prefixIcon: const Icon(Icons.title),
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
                              color: Colors.purple.shade300, width: 2),
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
                          return 'Only letters and numbers allowed';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: noteDescription,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Write your note here...',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 100),
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
                          borderSide: BorderSide(
                              color: Colors.purple.shade300, width: 2),
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
                            onPressed: () =>
                                _notesAddButtonClicked(notesDatas.key),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.purple.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save Note',
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

  void _editNote(NotesModal note, int index) {
    noteHead.text = note.title ?? '';
    noteDescription.text = note.description ?? '';

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
                key: noteFormKey,
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
                            Icons.edit,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Note',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Update your note',
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
                      controller: noteHead,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.title),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please add note title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: noteDescription,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 100),
                          child: Icon(Icons.description),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.blue.shade300, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please add your description';
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
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (noteFormKey.currentState!.validate()) {
                                note.title = noteHead.text.trim();
                                note.description = noteDescription.text.trim();
                                await Tripdb()
                                    .editDetails(notesDatas, notesDatas.key);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Update',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
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
  }

  void _confirmDelete(NotesModal note, int index) {
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
              const Text('Delete Note'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this note?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                notesDatas.notesModal!.removeAt(index);
                await Tripdb().editDetails(notesDatas, notesDatas.key);
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

  void _notesAddButtonClicked(var key) async {
    String titleText = noteHead.text.trim();
    String notesDescription = noteDescription.text.trim();

    if (noteFormKey.currentState!.validate()) {
      if (titleText.isNotEmpty && notesDescription.isNotEmpty) {
        final notesCarrier = NotesModal(
          title: titleText,
          description: notesDescription,
        );

        notesDatas.notesModal == null
            ? notesDatas.notesModal = [notesCarrier]
            : notesDatas.notesModal!.add(notesCarrier);

        await Tripdb().addnearbyplaces(notesDatas, key);

        if (mounted) {
          Navigator.pop(context);
          setState(() {
            noteHead.clear();
            noteDescription.clear();
          });
        }
      }
    }
  }
}
