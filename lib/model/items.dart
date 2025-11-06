import 'package:hive/hive.dart';

part 'items.g.dart';

@HiveType(typeId: 1)
class DuLieu {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;  // trường bạn đang dùng

  @HiveField(2)
  final String labelId; // id nhóm/label

  @HiveField(3)
  final DateTime createdAt;

  DuLieu({
    required this.id,
    required this.name,
    required this.labelId,
    required this.createdAt,
  });
}
