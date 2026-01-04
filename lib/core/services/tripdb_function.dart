import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
import 'package:travelapp/data/model/trip_model.dart';

ValueNotifier<List<Tripmodel>> tripnotifier = ValueNotifier([]);
ValueNotifier<List<ExpenceModal>> expencenotifier = ValueNotifier([]);
ValueNotifier<List<PhotosModal>> imageNotifier = ValueNotifier([]);
ValueNotifier<List<ChecklistModal>> checklistNotifier = ValueNotifier([]);
ValueNotifier<List<NotesModal>> notesNotifier = ValueNotifier([]);
final box1 = Hive.openBox<Tripmodel>('tripdbbox');

class Tripdb extends ChangeNotifier {
  //*Create function
  Future<void> addData(Tripmodel trip) async {
    final box = await box1;
    await box.add(trip);
    // await box.close();
    await getAll();
  }

  //*Read alltrips function
  Future getAll() async {
    final box = await box1;
    tripnotifier.value.clear();
    tripnotifier.value.addAll(box.values.toList());
    tripnotifier.notifyListeners();
    // box.close();
  }

  //*Detailing trip page places adding function
  Future addnearbyplaces(Tripmodel trip, int key) async {
    final box = await box1;
    await box.put(key, trip);
    
    expencenotifier.notifyListeners();
    notesNotifier.notifyListeners();
    checklistNotifier.notifyListeners();
  }

  Future<void> deletetrip(int key) async {
    final box = await box1;
    await box.delete(key);
    await getAll();
  }

  Future editDetails(Tripmodel value, int key) async {
    final box = await box1;
    
    var temp = box.get(key);
    
    temp = value;
    await box.put(key, temp);
    await getAll();
  }
}
