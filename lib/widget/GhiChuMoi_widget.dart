import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:vha_note/widget/ChinhSua_widget.dart';



class GhiChuMoi extends StatelessWidget {
  GhiChuMoi({Key? key,required this.item, required this.xoa,required this.index,required this.sua,}) : super(key:key);
  var item;
  var index;
  var sua;
  final Function xoa;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.only(bottom: 20),
      decoration:BoxDecoration(
        color: (index%2==0)
          ? const Color.fromARGB(255, 218, 37, 29)
          : const Color.fromARGB(255, 255, 255, 0),
        borderRadius:BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 0, 0, 0),
              )
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
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 40,
                  ),
                ),
                InkWell(
                  onTap:() async {
                    if(await confirm(context)){
                      xoa(item.id);
                    }
                    return;
                  },
                  child: const Icon(
                    Icons.delete_forever_outlined,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 40,
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

