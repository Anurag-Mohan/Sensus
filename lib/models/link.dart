 
import 'package:hive/hive.dart';

part 'link.g.dart';

@HiveType(typeId: 3)
class LinkItem extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String url;
  @HiveField(2)
  DateTime createdAt;

  LinkItem({required this.title, required this.url, required this.createdAt});
}