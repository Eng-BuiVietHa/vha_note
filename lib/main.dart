import 'package:flutter/material.dart';
import 'package:vha_note/widget/GhiChuMoi_widget.dart';
import 'package:vha_note/widget/NhapGhiChu_widget.dart';
import 'model/items.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DuLieuAdapter());
  await Hive.openBox<DuLieu>('ghichu_box');
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
  late Box<DuLieu> box;
  List<DuLieu> items = [];
  @override
  void initState() {
    super.initState();
    box = Hive.box<DuLieu>('ghichu_box');
    items = box.values.cast<DuLieu>().toList();
  }
  void ThemGhiChu(String name) async {
    final newItem = DuLieu(id: DateTime.now().toString(), name: name);
    await box.add(newItem);
    setState(() {
      items = box.values.cast<DuLieu>().toList();
  });
  }
  void SuaGhiChu(String id, String newName) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final newItem = DuLieu(id: id, name: newName);
      await box.putAt(index, newItem);
      setState(() {
        items = box.values.cast<DuLieu>().toList();
      });
    }
  }

  void XoaGhiChu(String id) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      await box.deleteAt(index);
      setState(() {
        items = box.values.cast<DuLieu>().toList();
      });
    }
  }  

  @override
  Widget build(BuildContext context){
    return Scaffold (

      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'N',
                style: TextStyle(
                  fontFamily:'AutumnFlowers',
                  fontSize:45,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text:'ote',
                style: TextStyle(
                  fontFamily: 'Bulgatti',
                  fontSize:28,
                  color:Colors.black,
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image:DecorationImage(image: AssetImage('assets/appbar.jpg'),
              fit:BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover, 
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: items.map((item) => GhiChuMoi(
              index: items.indexOf(item),
              item: item,
              xoa: XoaGhiChu,
              sua: SuaGhiChu,
            )).toList(),
          ),
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: Center(
          child: Icon(Icons.add,size: 50,color: Colors.orange,),
        ),
     )
    );
  }
}

