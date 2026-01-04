import 'package:hive_flutter/adapters.dart';
part 'atripdetail_modal.g.dart';

@HiveType(typeId: 4)
class NearbyPlacemodal extends HiveObject {
  @HiveField(0)
  String placename;
  @HiveField(1)
  String? description;
  NearbyPlacemodal({required this.description, required this.placename});
  // Clone method to avoid Hive object issues
  // TripDetail clone() {
  //   return TripDetail(
  //     notes: List<String>.from(notes ?? []),
  //     checklist: String.trim(checklist ?? []),
  //     nearplace: String.from(nearplace ?? []),
  //     spendexpence: List<int>.from(spendexpence ?? []),
  //     tripphotos: List<String>.from(tripphotos ?? []),
  //   );
  // }
}

@HiveType(typeId: 5)
class ChecklistModal extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  bool isChecked;
  ChecklistModal({required this.title,required this.isChecked});
}

@HiveType(typeId: 6)
class NotesModal extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  NotesModal({required this.title, required this.description});
}

@HiveType(typeId: 7)
class PhotosModal extends HiveObject {
  @HiveField(0)
  String? image;
  PhotosModal({required this.image});
}

@HiveType(typeId: 8)
class ExpenceModal extends HiveObject {
  @HiveField(0)
  String? expenceTitle;
  @HiveField(1)
  String? cost;
  ExpenceModal({required this.expenceTitle, required this.cost});
}
