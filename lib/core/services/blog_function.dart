import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:travelapp/core/services/tripdb_function.dart';
import 'package:travelapp/data/model/blog_modal.dart';

ValueNotifier<List<BlogModal>> blogNotifier = ValueNotifier([]);

class BlogDbFunc extends ChangeNotifier {
  //*blog adding function

  Future<void> blogAdd(BlogModal blog) async {
    final box = await Hive.openBox<BlogModal>('blogDb');
    await box.add(blog);
    await box.close();
    await allblog();
  }

  //*fetch all data from database

  Future allblog() async {
    final box = await Hive.openBox<BlogModal>('blogDb');
    blogNotifier.value.clear();
    blogNotifier.value.addAll(box.values.toList());
    blogNotifier.notifyListeners();
    box.close();
  }

  Future<void> deleteblog(int key) async {
    final box = await Hive.openBox<BlogModal>('blogDb');
    await box.delete(key);
    await allblog();
  }

  Future<void> editBlog(int key, BlogModal edblog) async {
    final box = await Hive.openBox<BlogModal>('blogDb');
    await box.putAt(key, edblog);
    
    tripnotifier.value.clear();
    blogNotifier.notifyListeners();
    await box.close();
    await allblog();
  }
}
