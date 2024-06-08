import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> with AutomaticKeepAliveClientMixin{
  final List<Map<String, dynamic>> _checkList = [];

  @override
  void initState() {
    super.initState();
    _checkList.add({
      'controller': TextEditingController(),
      'isChecked': false,
    });
  }

  @override
  void dispose() {
    for (var item in _checkList) {
      item['controller'].dispose();
    }
    super.dispose();
  }

  void _addTextField(){
    setState(() {
      _checkList.add({
        'controller' : TextEditingController(),
        'isChecked' : false,
      });
    });
  }

  void _removeTextField(int index){
    setState(() {
      _checkList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _checkList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _checkList[index]['isChecked'],
                    onChanged: (bool? value) {
                      setState(() {
                        _checkList[index]['isChecked'] = value!;
                      });
                    },
                  ),
                  title: TextField(
                    controller: _checkList[index]['controller'],
                    decoration: InputDecoration(
                      hintText: '할 일 입력',
                      suffixIcon: IconButton(
                        onPressed: (){
                          _checkList[index]['controller'].clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addTextField,
              child: const Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: (){
                if(_checkList.isNotEmpty){
                  _removeTextField(_checkList.length - 1);
                }
              },
              child: const Icon(Icons.remove),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
