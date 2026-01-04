import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:travelapp/data/model/user_model.dart';

ValueNotifier<Usermodel?> usernotifier = ValueNotifier<Usermodel?>(null);

class Userdb {
  static const String boxName = 'userdbbox';

  /// CREATE (first time)
  Future<void> adduser(Usermodel user) async {
    final box = await Hive.openBox<Usermodel>(boxName);

    await box.clear(); // ensure single user
    await box.add(user);

    usernotifier.value = user;
  }

  /// READ
  static Future<void> loadUser() async {
    final box = await Hive.openBox<Usermodel>(boxName);

    if (box.isNotEmpty) {
      usernotifier.value = box.getAt(0);
    } else {
      usernotifier.value = null;
    }
  }

  /// UPDATE (edit profile)
  static Future<void> updateUser(Usermodel updatedUser) async {
    final box = await Hive.openBox<Usermodel>(boxName);

    if (box.isNotEmpty) {
      await box.putAt(0, updatedUser);
      usernotifier.value = updatedUser; // 🔥 instant UI update
    }
  }

  /// DELETE / LOGOUT
  Future<void> clearUser() async {
    final box = await Hive.openBox<Usermodel>(boxName);
    await box.clear();
    usernotifier.value = null;
  }
}
