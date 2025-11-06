import 'package:flutter/material.dart';
import 'package:vha_note/widget/GhiChuMoi_widget.dart';
import 'package:vha_note/widget/NhapGhiChu_widget.dart';
import '../model/items.dart';
import '../model/label.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyApp extends StatefulWidget {
  final String labelId;
  MyApp({Key? key, required this.labelId}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<DuLieu> box;
  late Box<Label> labelBox;
  List<DuLieu> items = [];
  Label? currentLabel;

  @override
  void initState() {
    super.initState();
    box = Hive.box<DuLieu>('ghichu_box');
    labelBox = Hive.box<Label>('label_box');
    _loadData();
  }

  void _loadData() {
    final allItems = box.values.cast<DuLieu>().toList();
    final label = labelBox.values.cast<Label>().firstWhere(
      (label) => label.id == widget.labelId,
      orElse: () => Label(id: '0', name: 'Nhóm không xác định', colorValue: 0xFFFFFFFF),
    );
    setState(() {
      items = allItems.where((item) => item.labelId == widget.labelId).toList();
      currentLabel = label;
    });
  }

  void ThemGhiChu(String name) async {
    final newItem = DuLieu(
      id: DateTime.now().toIso8601String(),
      name: name,
      labelId: widget.labelId,
      createdAt: DateTime.now(),
    );
    await box.add(newItem);
    _loadData();
  }

  void SuaGhiChu(String id, String newName) async {
    final fullList = box.values.toList();
    final indexInBox = fullList.indexWhere((element) => element.id == id);
    if (indexInBox != -1) {
      final oldItem = fullList[indexInBox] as DuLieu;
      final newItem = DuLieu(
        id: id,
        name: newName,
        labelId: oldItem.labelId,
        createdAt: oldItem.createdAt,
      );
      await box.putAt(indexInBox, newItem);
      _loadData();
    }
  }

  void XoaGhiChu(String id) async {
    final fullList = box.values.toList();
    final indexInBox = fullList.indexWhere((element) => element.id == id);
    if (indexInBox != -1) {
      await box.deleteAt(indexInBox);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Nhóm: ',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              TextSpan(
                text: currentLabel?.name ?? 'Chưa xác định',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  fontFamily: 'Bulgatti',
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: items
                .map(
                  (item) => GhiChuMoi(
                    index: items.indexOf(item),
                    item: item,
                    xoa: XoaGhiChu,
                    sua: SuaGhiChu,
                  ),
                )
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return NhapGhiChu(addTask: ThemGhiChu);
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 50,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}
