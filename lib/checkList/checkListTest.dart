import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'EditCheckListPage.dart';
import 'addCheckListItemPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  final List<ChecklistItem> _items = [];
  final List<ChecklistSource> _checklists = [];
  String _searchQuery = '';
  ChecklistSource? _selectedChecklist;

  ChecklistModel() {
    _loadData();
  }

  List<ChecklistItem> get items => _items
      .where((item) =>
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  List<ChecklistSource> get filteredChecklists {
    return _checklists
        .where((checklist) =>
    checklist.date.year == _selectedDate.year &&
        checklist.date.month == _selectedDate.month)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<ChecklistSource> get filteredChecklistsWithString {
    return _checklists
        .where((checklist) =>
    checklist.date.year == _selectedDate.year &&
        checklist.date.month == _selectedDate.month &&
        checklist.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<ChecklistSource> get checklists => _checklists;

  ChecklistSource? get selectedChecklist => _selectedChecklist;

  void selectChecklist(ChecklistSource checklist) {
    _selectedChecklist = checklist;
    notifyListeners();
  }

  void addItem(String title) {
    _items.add(ChecklistItem(title: title));
    saveData();
    notifyListeners();
  }

  void toggleItem(int index) {
    if (_selectedChecklist != null &&
        index >= 0 &&
        index < _selectedChecklist!.items.length) {
      _selectedChecklist!.items[index].isChecked =
          !_selectedChecklist!.items[index].isChecked;
      saveData();
      notifyListeners();
    }
  }

  void updateItem(int index, String newTitle) {
    if (_selectedChecklist != null &&
        index >= 0 &&
        index < _selectedChecklist!.items.length) {
      _selectedChecklist!.items[index].title = newTitle;
      saveData();
      notifyListeners();
    }
  }

  void removeItem(int index) {
    _items.removeAt(index);
    saveData();
    notifyListeners();
  }

  void removeChecklistItem(int itemIndex) {
    _selectedChecklist?.items.removeAt(itemIndex);
    saveData();
    notifyListeners();
  }

  void addChecklist(ChecklistSource checklist) {
    _checklists.add(checklist);
    saveData();
    notifyListeners();
  }

  void removeChecklist(ChecklistSource checklist) {
    _checklists.remove(checklist);
    saveData();
    notifyListeners();
  }

  void updateChecklist(ChecklistSource oldChecklist, ChecklistSource newChecklist) {
    final index = _checklists.indexOf(oldChecklist);
    if (index != -1) {
      _checklists[index] = newChecklist;
      saveData();
      notifyListeners();
    }
  }

  void updateChecklistItem(int itemIndex, String newTitle) {
    if (_selectedChecklist != null &&
        itemIndex >= 0 &&
        itemIndex < _selectedChecklist!.items.length) {
      _selectedChecklist!.items[itemIndex].title = newTitle;
      saveData();
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'checklists', jsonEncode(_checklists.map((e) => e.toJson()).toList()));
    prefs.setString(
        'items', jsonEncode(_items.map((e) => e.toJson()).toList()));
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final checklistsString = prefs.getString('checklists');
    final itemsString = prefs.getString('items');

    if (checklistsString != null) {
      final List<dynamic> decodedChecklists = jsonDecode(checklistsString);
      _checklists.clear();
      _checklists.addAll(
          decodedChecklists.map((e) => ChecklistSource.fromJson(e)).toList());
    }

    if (itemsString != null) {
      final List<dynamic> decodedItems = jsonDecode(itemsString);
      _items.clear();
      _items
          .addAll(decodedItems.map((e) => ChecklistItem.fromJson(e)).toList());
    }

    notifyListeners();
  }
}

class ChecklistSource {
  String title;
  DateTime date;
  List<ChecklistItem> items;

  ChecklistSource(
      {required this.title, required this.date, required this.items});

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory ChecklistSource.fromJson(Map<String, dynamic> json) =>
      ChecklistSource(
        title: json['title'],
        date: DateTime.parse(json['date']),
        items: List<ChecklistItem>.from(
            json['items'].map((e) => ChecklistItem.fromJson(e))),
      );
}

class ChecklistItem {
  String title;
  bool isChecked;

  ChecklistItem({required this.title, this.isChecked = false});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isChecked': isChecked,
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        title: json['title'],
        isChecked: json['isChecked'],
      );
}

class ChecklistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistModel>(
      builder: (context, checklistModel, child) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Text('Select Year and Month'),
                                  content: Column(
                                    children: [
                                      SizedBox(
                                        height: 150,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime: checklistModel.selectedDate,
                                          onDateTimeChanged: (DateTime newDateTime) {
                                            checklistModel.setSelectedDate(newDateTime);
                                          },
                                          use24hFormat: true,
                                          maximumDate: DateTime(2100, 12, 31),
                                          minimumYear: 2000,
                                          maximumYear: 2100,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        Text(
                          '${checklistModel.selectedDate.year}-${checklistModel.selectedDate.month.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => AddChecklistItemPage(),
                            fullscreenDialog: true,
                          ),
                        ).then((newChecklist) {
                          if (newChecklist != null) {
                            // 새 체크리스트를 받아서 모델에 추가합니다.
                            Provider.of<ChecklistModel>(context, listen: false).addChecklist(newChecklist);
                            Provider.of<ChecklistModel>(context, listen: false).notifyListeners();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: Checklist()), // Ensure Checklist is still here
            ],
          ),
        );
      },
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
              childAspectRatio: 0.7,
            ),
            itemCount: checklistModel.filteredChecklistsWithString.length,
            itemBuilder: (context, index) {
              final checklist = checklistModel.filteredChecklistsWithString[index];
              return GestureDetector(
                onTap: () {
                  checklistModel.selectChecklist(checklist);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: EditChecklistDialog(checklist: checklist),
                      );
                    },
                  ).then((updatedChecklist) {
                    if (updatedChecklist != null) {
                      Provider.of<ChecklistModel>(context, listen: false)
                          .updateChecklist(checklist, updatedChecklist);
                    }
                  });
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${checklist.date.year}-${checklist.date.month.toString().padLeft(2, '0')}-${checklist.date.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          checklist.title,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: checklist.items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = checklist.items[itemIndex];
                              return Row(
                                children: [
                                  Checkbox(
                                    value: item.isChecked,
                                    onChanged: (bool? value) {
                                      checklistModel.toggleItem(itemIndex);
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
