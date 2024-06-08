import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addCheckListItemPage.dart';

class CheckListView extends StatelessWidget {
  const CheckListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChecklistModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChecklistPage(),
      ),
    );
  }
}

class ChecklistModel extends ChangeNotifier {
  final List<ChecklistItem> _items = [];
  final List<ChecklistSource> _checklists = [];
  String _searchQuery = '';

  List<ChecklistItem> get items => _items
      .where((item) =>
      item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  void addItem(String title) {
    _items.add(ChecklistItem(title: title));
    notifyListeners();
  }

  void toggleItem(int index) {
    _items[index].isChecked = !_items[index].isChecked;
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void addChecklist(ChecklistSource checklist) {
    _checklists.add(checklist);
    notifyListeners();
  }

  void removeChecklist(int index) {
    _checklists.removeAt(index);
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateItem(int index, String newTitle) {
    _items[index].title = newTitle;
    notifyListeners();
  }
}

class ChecklistSource {
  String title;
  DateTime date;
  List<ChecklistItem> items;

  ChecklistSource({required this.title, required this.date, required this.items});
}

class ChecklistItem {
  String title;
  bool isChecked;

  ChecklistItem({required this.title, this.isChecked = false});
}

class ChecklistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
            child: SearchBar(),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => AddChecklistItemPage(),
                      fullscreenDialog: true, // 전체 화면 대화 상자로 열림
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(child: Checklist()),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          contentPadding: EdgeInsets.fromLTRB(8.0, 10, 0, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (query) {
          Provider.of<ChecklistModel>(context, listen: false)
              .updateSearchQuery(query);
        },
      ),
    );
  }
}

class Checklist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Consumer<ChecklistModel>(
        builder: (context, checklistModel, child) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7, // 적절한 비율로 조정
            ),
            itemCount: checklistModel.items.length,
            itemBuilder: (context, index) {
              final item = checklistModel.items[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // 왼쪽 상단에 정렬된 체크박스와 텍스트
                    Row(
                      children: [
                        Checkbox(
                          value: item.isChecked,
                          onChanged: (bool? value) {
                            checklistModel.toggleItem(index);
                          },
                        ),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    Spacer(), // 남은 공간을 채우기 위해 Spacer 사용
                    // 우측 하단에 정렬된 아이콘들
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return EditChecklistItemDialog(
                                  index: index,
                                  currentTitle: item.title,
                                  checklistModel: checklistModel,
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete Item'),
                                  content: Text(
                                      'Are you sure you want to delete this item?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        checklistModel.removeItem(index);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditChecklistItemDialog extends StatefulWidget {
  final int index;
  final String currentTitle;
  final ChecklistModel checklistModel;

  EditChecklistItemDialog({
    required this.index,
    required this.currentTitle,
    required this.checklistModel,
  });

  @override
  _EditChecklistItemDialogState createState() =>
      _EditChecklistItemDialogState();
}

class _EditChecklistItemDialogState extends State<EditChecklistItemDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Item'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'New Title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.checklistModel.updateItem(widget.index, _controller.text);
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
