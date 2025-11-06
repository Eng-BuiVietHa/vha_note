import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/label.dart';
import '../widget/MyApp.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class LabelListScreen extends StatefulWidget {
  const LabelListScreen({Key? key}) : super(key: key);

  @override
  State<LabelListScreen> createState() => _LabelListScreenState();
}

class _LabelListScreenState extends State<LabelListScreen> {
  late Box<Label> labelBox;
  List<Label> labels = [];

  @override
  void initState() {
    super.initState();
    labelBox = Hive.box<Label>('label_box');
    loadLabels();
  }

  void loadLabels() {
    setState(() {
      labels = labelBox.values.toList();
    });
  }

  void addLabel() {
    String newName = '';
    Color newColor = Colors.orange;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Tên nhóm mới',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => newName = val,
                    style: TextStyle(
                      fontFamily: 'AutumnFlowers',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Chọn màu: '),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Chọn màu nhóm'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: newColor,
                                  onColorChanged: (color) {
                                    setModalState(() {
                                      newColor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Đóng'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: newColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (newName.trim().isEmpty) return;
                        final newLabel = Label(
                          id: DateTime.now().toIso8601String(),
                          name: newName.trim(),
                          colorValue: newColor.value,
                        );
                        await labelBox.add(newLabel);
                        loadLabels();
                        Navigator.pop(context);
                      },
                      child: Text('Thêm nhóm'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void editLabel(Label label) {
    String updatedName = label.name;
    Color updatedColor = Color(label.colorValue);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Sửa tên nhóm',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: updatedName),
                    onChanged: (val) => updatedName = val,
                    style: TextStyle(
                      fontFamily: 'Bulgatti',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Chọn màu: '),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Chọn màu nhóm'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: updatedColor,
                                  onColorChanged: (color) {
                                    setModalState(() {
                                      updatedColor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Đóng'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: updatedColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (updatedName.trim().isEmpty) return;
                        final updatedLabel = Label(
                          id: label.id,
                          name: updatedName.trim(),
                          colorValue: updatedColor.value,
                        );
                        final index = labelBox.values.toList().indexWhere((e) => e.id == label.id);
                        if (index != -1) {
                          await labelBox.putAt(index, updatedLabel);
                          loadLabels();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Lưu thay đổi'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void deleteLabel(Label label) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa nhóm'),
        content: Text('Bạn có chắc chắn muốn xóa nhóm "${label.name}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Xóa')),
        ],
      ),
    );

    if (confirmed == true) {
      final index = labelBox.values.toList().indexWhere((e) => e.id == label.id);
      if (index != -1) {
        await labelBox.deleteAt(index);
        loadLabels();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note',
          style: TextStyle(
            fontFamily: 'AutumnFlowers',
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbar.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
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
        child: ListView.separated(
          itemCount: labels.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, index) {
            final label = labels[index];
            return ListTile(
              leading: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Color(label.colorValue),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              title: Text(
                label.name,
                style: TextStyle(
                  fontFamily: 'Bulgatti',
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => editLabel(label),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteLabel(label),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyApp(labelId: label.id)),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addLabel,
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, size: 36),
      ),
    );
  }
}
