import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/custom_buttons.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/trip_model.dart';

class CustomCard extends StatefulWidget {
  final VoidCallback fn;

  final Tripmodel data;
  final int colorIndex;
  const CustomCard(
      {super.key,
      required this.colorIndex,
      required this.data,
      required this.fn});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late TextEditingController editcontentcontroller;
  late TextEditingController edittitlecontroller;
  final GlobalKey<FormState> editnoteformkey = GlobalKey<FormState>();
  late Tripmodel newdatacarrier;
  List<Color> colorSelector = [
    const Color.fromARGB(255, 216, 222, 227),
    const Color.fromARGB(255, 145, 177, 204),
    const Color.fromARGB(255, 106, 138, 163),
    const Color.fromARGB(255, 81, 131, 170)
  ];

  @override
  void initState() {
    super.initState();
    newdatacarrier = widget.data;
    edittitlecontroller = TextEditingController(
        text: widget.data.notesModal![widget.colorIndex].title);
    editcontentcontroller = TextEditingController(
        text: widget.data.notesModal![widget.colorIndex].description);
  }

  @override
  Widget build(BuildContext context) {
    Color exactColor = colorSelector[widget.colorIndex % colorSelector.length];
    return Card(
      color: exactColor,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.my_library_books_outlined),
            title: CustomText(
                text: widget.data.notesModal![widget.colorIndex].title),
            subtitle: CustomText(
                text: widget.data.notesModal![widget.colorIndex].description),
            trailing: PopupMenuButton<String>(
              onSelected: (String value) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title:
                                  const CustomText(text: 'Confirm to delete'),
                              content: const CustomText(
                                  text:
                                      'Are you sure ,you wanted to delete this note'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const CustomText(text: 'No')),
                                TextButton(
                                    onPressed: () async {
                                      widget.data.notesModal!
                                          .removeAt(widget.colorIndex);
                                      await Tripdb().editDetails(
                                          widget.data, widget.data.key);
                                      // print('its working delete');
                                      widget.fn();
                                       Navigator.pop(context);
                                    },
                                    child: const CustomText(text: 'Yes'))
                              ],
                            ));
                  },
                  value: 'option1',
                  child: const Text('Delete'),
                ),
                PopupMenuItem<String>(
                  value: 'option2',
                  child: const Text('Edit'),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SingleChildScrollView(
                              child: Container(
                                //!
                                height: 360,
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 20),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30)),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 20,
                                    left: 20,
                                  ),
                                  child: Form(
                                    //!
                                    key: editnoteformkey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //!
                                        Container(
                                          width: 40,
                                          height: 6.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.5),
                                            color: const Color.fromARGB(
                                                255, 202, 202, 202),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const CustomText(
                                          text: 'Save your notes',
                                          size: 20,
                                          color: Colors.black, //!
                                          fontweight: FontWeight.bold,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: edittitlecontroller,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                              hintText: ' type... title',
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              suffixIconColor:
                                                  const Color.fromARGB(
                                                      255, 121, 120, 120),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    edittitlecontroller.clear();
                                                  },
                                                  icon: const Icon(Icons
                                                      .restart_alt_rounded)),
                                              labelText: 'Title',
                                              labelStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 121, 120, 120))),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please add note title';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        TextFormField(
                                          controller: editcontentcontroller,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              suffixIconColor:
                                                  const Color.fromARGB(
                                                      255, 121, 120, 120),
                                              hintText: ' type... description',
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    editcontentcontroller
                                                        .clear();
                                                  },
                                                  icon: const Icon(Icons
                                                      .restart_alt_rounded)),
                                              labelText: 'Description',
                                              labelStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 121, 120, 120))),
                                          validator: (value) {
                                            //!
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'please add your description';
                                            } else if (value.trim() ==
                                                value.replaceAll(
                                                    RegExp(r'[^\d]'), '')) {
                                              return 'Description should not only contain numbers.';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        CustomButton(
                                            width: double.infinity,
                                            color: Colors.blue,
                                            child: const CustomText(
                                              color: Colors.white,
                                              text: 'Save',
                                            ),
                                            onPressed: () {
                                              editNoteButtonClicked(
                                                  newdatacarrier.key);
                                            }),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const CustomText(
                                              text: 'Cancel',
                                              color: Color.fromARGB(
                                                  255, 101, 100, 100),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          )),
    );
  }

  editNoteButtonClicked(dynamic key) async {
    String title = edittitlecontroller.text.trim();
    String description = editcontentcontroller.text.trim();
    if (editnoteformkey.currentState!.validate()) {
      newdatacarrier.notesModal![widget.colorIndex].title = title;
      newdatacarrier.notesModal![widget.colorIndex].description = description;

      await Tripdb().editDetails(newdatacarrier, key);
      Navigator.pop(context);
      setState(() {
        editcontentcontroller.clear();
        edittitlecontroller.clear();
      });
    }
  }
}
