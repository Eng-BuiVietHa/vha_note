import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

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
      backgroundColor: const Color.fromARGB(255, 143, 69, 32),
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
          children: items.map((item) => GhiChuMoi(item : item, xoa: XoaGhiChu,)).toList(),
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
        child: Icon(Icons.add,size: 60,color: Colors.orange,),
      )
    );
  }
}

class NhapGhiChu extends StatelessWidget {
  NhapGhiChu({
    Key? key,
    required this.addTask
  }): super(key:key);
  final Function addTask;

  TextEditingController controller=TextEditingController();

  void SauKhiNhap(BuildContext context){
    final name = controller.text;
    if(name.isEmpty){
      return;
    }
    addTask(name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal:20, vertical:20),
        child: Column(
          children:[
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nhập ghi chú mới',
              ),
            ),
            const SizedBox(
              height:20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => SauKhiNhap(context) ,
                child:const Text('Thêm'),
              ),
            ),
          ]
        )
      ),
    );
  }
}
class GhiChuMoi extends StatelessWidget {
  GhiChuMoi({Key? key,required this.item, required this.xoa}) : super(key:key);
  var item;
  final Function xoa;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.only(bottom: 20),
      decoration:BoxDecoration(
        color: Colors.amber,
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
                color: Colors.red,
              )
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
                color: Colors.black54,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DuLieu{
  final String id;
  final String name;

  DuLieu({
    required this.id,
    required this.name
  });
}