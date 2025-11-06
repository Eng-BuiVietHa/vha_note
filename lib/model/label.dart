import 'package:hive/hive.dart';

part 'label.g.dart';

@HiveType(typeId: 2)
class Label {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int colorValue;

  Label({
    required this.id,
    required this.name,
    required this.colorValue,
  });
}
