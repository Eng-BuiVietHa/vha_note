import 'package:flutter/material.dart';
import 'package:vha_note/widget/ChinhSua_widget.dart';

class GhiChuMoi extends StatelessWidget {
  final dynamic item;
  final int index;
  final Function(String id) xoa;
  final Function(String id, String newName) sua;

  GhiChuMoi({
    Key? key,
    required this.item,
    required this.xoa,
    required this.index,
    required this.sua,
  }) : super(key: key);

  Future<bool?> _showConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa ghi chú "${item.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? const Color.fromARGB(255, 189, 250, 160)
            : const Color.fromARGB(255, 212, 154, 231),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    final newText = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChinhSua(item: item),
                      ),
                    );
                    if (newText != null && newText is String && newText.isNotEmpty) {
                      sua(item.id, newText);
                    }
                  },
                  child: const Icon(
                    Icons.edit,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(width: 5),
                InkWell(
                  onTap: () async {
                    final confirmed = await _showConfirmDialog(context);
                    if (confirmed == true) {
                      xoa(item.id);
                    }
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
