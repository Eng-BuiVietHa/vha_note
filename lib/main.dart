import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/label.dart';
import 'model/items.dart';
import 'widget/LabelListScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(LabelAdapter());
  Hive.registerAdapter(DuLieuAdapter());

  await Hive.openBox<DuLieu>('ghichu_box');
  await Hive.openBox<Label>('label_box');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LabelListScreen(),
  ));
}
