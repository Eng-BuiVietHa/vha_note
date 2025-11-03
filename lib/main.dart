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
          ? const Color.fromARGB(255, 85, 172, 252)
          : const Color.fromARGB(222, 251, 76, 76),
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

class DuLieu{
  final String id;
  final String name;

  DuLieu({
    required this.id,
    required this.name
  });
}

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

