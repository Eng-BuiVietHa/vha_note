import 'package:flutter/material.dart';

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
