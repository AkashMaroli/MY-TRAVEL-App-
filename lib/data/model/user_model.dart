import 'package:hive_flutter/adapters.dart';
part 'user_model.g.dart';

@HiveType(typeId: 2)
class Usermodel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String city;
  @HiveField(2)
  String email;
  @HiveField(3)
  String age;
  @HiveField(4)
  String? pic;

  Usermodel(
      {required this.name,
      required this.city,
      required this.email,
      required this.age,
      this.pic});
}
