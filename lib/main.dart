import 'package:flutter/material.dart';
import 'package:vha_note/widget/GhiChuMoi_widget.dart';
import 'package:vha_note/widget/NhapGhiChu_widget.dart';

import 'model/items.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}
class MyApp extends StatefulWidget{
  MyApp({Key?key}):super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<DuLieu> items = [];

  void SuaGhiChu(String id, String newName) {
  setState(() {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      items[index] = DuLieu(id: id, name: newName);
    }
  });
}

  void ThemGhiChu(String name){
    final newItem = DuLieu(id: DateTime.now().toString(),name: name);
    setState((){
      items.add(newItem);
    });
  }
  void XoaGhiChu(String id){
   setState((){
     items.removeWhere((item) => item.id == id);
   });

  }

  @override
  Widget build(BuildContext context){
    return Scaffold (
      backgroundColor: const Color.fromARGB(255, 190, 244, 188),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Note VHA',
          style:TextStyle(fontSize: 40),
        ),
        backgroundColor: Colors.blueAccent,
        
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical:20),
        child: Column(
          children: items.map((item) => GhiChuMoi(
            index : items.indexOf(item),
            item : item, xoa: XoaGhiChu,sua: SuaGhiChu,)).toList(),
        ),
      ),
      floatingActionButton : FloatingActionButton(
        onPressed : (){
          showModalBottomSheet(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top:Radius.circular((20)))),
            isScrollControlled: true,
            context: context,
            builder:(BuildContext content) {
              return NhapGhiChu(addTask : ThemGhiChu);
            },
          );
        },
        child: Center(
          child: Icon(Icons.add,size: 50,color: Colors.orange,),
        ),
     )
    );
  }
}

