import 'package:hive/hive.dart';

part 'items.g.dart';

@HiveType(typeId: 1)
class DuLieu {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  DuLieu({
    required this.id,
    required this.name,
  });
}
