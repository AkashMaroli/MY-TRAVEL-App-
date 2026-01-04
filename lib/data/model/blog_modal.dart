import 'package:hive_flutter/adapters.dart';
part 'blog_modal.g.dart';
@HiveType(typeId: 3)
class BlogModal extends HiveObject {
 @HiveField(0)
  final String blogTitle;
  @HiveField(1)
  final String blogImage;
  @HiveField(2)
  final String blogContent;

  BlogModal(
      {required this.blogTitle,
      required this.blogImage,
      required this.blogContent});
}
