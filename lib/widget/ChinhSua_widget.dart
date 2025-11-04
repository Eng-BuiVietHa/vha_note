import 'package:flutter/material.dart';
import '../model/items.dart';
class ChinhSua extends StatelessWidget {
  final DuLieu item;
  const ChinhSua({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: item.name); // Ghi chú cũ hiển thị sẵn

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa ghi chú'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sửa nội dung ghi chú',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, controller.text);
                },
                child: const Text('Lưu thay đổi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
