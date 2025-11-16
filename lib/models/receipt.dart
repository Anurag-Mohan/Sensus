import 'package:hive/hive.dart';

part 'receipt.g.dart';

@HiveType(typeId: 2)
class Receipt extends HiveObject {
  @HiveField(0)
  String storeName;
  @HiveField(1)
  String? amount;
  @HiveField(2)
  String fullText;
  @HiveField(3)
  DateTime createdAt;

  Receipt({required this.storeName, this.amount, required this.fullText, required this.createdAt});
}