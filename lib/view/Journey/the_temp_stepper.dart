// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/custom_buttons.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';

import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';

// ignore: must_be_immutable
class NearbyPlaceaddPage extends StatefulWidget {
  Tripmodel placeobj;

  NearbyPlaceaddPage({
    super.key,
    required this.placeobj,
  });

  @override
  State<NearbyPlaceaddPage> createState() => _NearbyPlaceaddPageState();
}

class _NearbyPlaceaddPageState extends State<NearbyPlaceaddPage> {
  late Tripmodel placeobj1;
  final GlobalKey<FormState> placepageformkey = GlobalKey<FormState>();
  int _index = 0;
  late int _totalSteps;
  final TextEditingController placename = TextEditingController();
  final TextEditingController placedescription = TextEditingController();
  @override
  void initState() {
    super.initState();
    placeobj1 = widget.placeobj;
    _totalSteps = placeobj1.nearbyPlacemodal?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 125),
          child: CustomButton(
              child: CustomText(text: 'Add Nearby place'),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SingleChildScrollView(
                            child: Container(
                              height: 320,
                              width: double.infinity,
                              padding: EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                  color:
                                      const Color.fromARGB(255, 0, 117, 212)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: placepageformkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                          text: 'Add place want to visit',
                                          size: 20,
                                          color: Colors.white),
                                      TextFormField(
                                        controller: placename,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            labelText: 'Place name',
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            suffixIcon: Icon(Icons.place)),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'please add your Place';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      TextFormField(
                                        controller: placedescription,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            labelText: 'Description',
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            suffixIcon: Icon(
                                                Icons.description_outlined)),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'please add your Description';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CustomButton(
                                          color: Colors.white,
                                          child: CustomText(text: 'Add'),
                                          onPressed: () {
                                            bottomsheetaddbuttonclicked(
                                                placeobj1.key);
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )).then((value) {
                  setState(() {});
                });
              }),
        ),
        placeobj1.nearbyPlacemodal != null
            ? Expanded(
                child: Builder(builder: (context) {
                  return Stepper(
                    currentStep: _index,
                    onStepCancel: () {
                      if (_index > 0) {
                        setState(() {
                          _index -= 1;
                        });
                      }
                    },
                    onStepContinue: () {
                      if (_index < _totalSteps - 1) {
                        setState(() {
                          _index += 1;
                        });
                      } else {
                        // Show a completion message or perform another action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nearby places Completed!'),
                            backgroundColor: Colors.blue,
                            shape: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        );
                      }
                    },
                    onStepTapped: (int index) {
                      setState(() {
                        _index = index;
                      });
                    },
                    steps: List.generate(
                        placeobj1.nearbyPlacemodal?.length ?? 0, (index) {
                      return Step(
                        title:
                            Text(placeobj1.nearbyPlacemodal![index].placename),
                        content: Text(''),
                        isActive: _index >= index,
                        state: _index > index
                            ? StepState.complete
                            : StepState.indexed,
                      );
                    }),
                  );
                }),
              )
            : SizedBox(),
      ],
    );
  }

  bottomsheetaddbuttonclicked(dynamic key) async {
    final placeName = placename.text.trim();
    final placeDetail = placedescription.text.trim();

    if (placepageformkey.currentState!.validate()) {
      if (placeName.isNotEmpty && placeDetail.isNotEmpty) {
        final newplace = NearbyPlacemodal(
            description: placedescription.text, placename: placename.text);
        placeobj1.nearbyPlacemodal == null
            ? placeobj1.nearbyPlacemodal = [newplace]
            : placeobj1.nearbyPlacemodal!.add(newplace);

        await Tripdb().addnearbyplaces(placeobj1, key);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }
}
