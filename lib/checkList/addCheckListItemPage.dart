import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkListTest.dart';

class AddChecklistItemPage extends StatefulWidget {
  @override
  _AddChecklistItemPageState createState() => _AddChecklistItemPageState();
}

class _AddChecklistItemPageState extends State<AddChecklistItemPage> {
  final TextEditingController _titleController = TextEditingController();
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _itemController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _addNewItem(String itemTitle) {
    setState(() {
      _items.add({'title': itemTitle, 'isChecked': false});
      _itemController.clear();
    });
  }

  void _updateItemTitle(int index, String title) {
    setState(() {
      _items[index]['title'] = title;
    });
  }

  void _toggleItemChecked(int index, bool? isChecked) {
    setState(() {
      _items[index]['isChecked'] = isChecked ?? false;
    });
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Color.fromARGB(255, 255, 255, 255),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    initialDateTime: selectedDate,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
                CupertinoButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Checklist Item'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 상단 날짜 선택
            Row(
              children: [
                Text(
                  "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _showDatePicker(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // 중단 체크리스트 제목 입력 필드
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Checklist Title',
              ),
            ),
            SizedBox(height: 16.0),
            // 하단 체크박스와 텍스트 추가하는 부분
            Expanded(  // Expanded를 사용하여 ListView가 남은 공간을 차지하도록 설정
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Checkbox(
                        value: _items[index]['isChecked'],
                        onChanged: (bool? value) {
                          _toggleItemChecked(index, value);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (text) {
                            _updateItemTitle(index, text);
                          },
                          decoration: InputDecoration(
                            hintText: 'Item ${index + 1}',
                          ),
                          controller: TextEditingController(text: _items[index]['title']),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // 항목 추가 필드 및 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintText: 'New Item',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_itemController.text.isNotEmpty) {
                      _addNewItem(_itemController.text);
                    }
                  },
                ),
              ],
            ),
            // 저장 버튼
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final items = _items
                    .map((item) => ChecklistItem(title: item['title'], isChecked: item['isChecked']))
                    .toList();

                final checklist = ChecklistSource(title: title, date: selectedDate, items: items);

                // ChecklistModel에 새 아이템을 추가하는 로직 구현
                Provider.of<ChecklistModel>(context, listen: false).addChecklist(checklist);

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}