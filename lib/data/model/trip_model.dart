import 'package:hive_flutter/adapters.dart';
import 'package:travelapp/data/model/atripdetail_modal.dart';
part 'trip_model.g.dart';

@HiveType(typeId: 1)
class Tripmodel extends HiveObject {
  @HiveField(0)
  String destination;
  @HiveField(1)
  DateTime startdate;
  @HiveField(2)
  DateTime enddate;
  @HiveField(3)
  int budget;
  @HiveField(4)
  String? image;
  @HiveField(5)
  List<NearbyPlacemodal>? nearbyPlacemodal;
  @HiveField(6)
  List<ChecklistModal>? checklistModal;
  @HiveField(7)
  List<NotesModal>? notesModal;
  @HiveField(8)
  List<PhotosModal>? photosModal;
  @HiveField(9)
    List <ExpenceModal>? expenceModal;
  Tripmodel(
      {required this.destination,
      required this.startdate,
      required this.enddate,
      required this.budget,
      this.checklistModal,this.nearbyPlacemodal,this.notesModal,
      this.expenceModal,this.photosModal,
      this.image});
}
