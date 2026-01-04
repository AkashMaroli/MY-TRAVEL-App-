import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/trip_model.dart';

// ignore: must_be_immutable
class SinglePicViewScreen extends StatelessWidget {
  Tripmodel picviewobj;
  int selectedIndex;
  SinglePicViewScreen(
      {super.key, required this.picviewobj, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: CustomText(text: ''),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              picviewobj.photosModal?.removeAt(selectedIndex);
              await Tripdb()
                  .editDetails(picviewobj, picviewobj.key)
                  .then((value) {
                Navigator.pop(context);
                
              });

              //  
            },
            icon: Icon(Icons.delete),
            color: Colors.white,
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.file(
                  File(picviewobj.photosModal![selectedIndex].image ?? '')),
            ],
          ),
        ),
      ),
    );
  }
}
