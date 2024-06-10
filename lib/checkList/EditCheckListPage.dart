import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkListTest.dart';

class EditChecklistDialog extends StatefulWidget {
  final ChecklistSource checklist;
  const EditChecklistDialog({required this.checklist});

  @override
  _EditChecklistDialogState createState() => _EditChecklistDialogState();
}

class _EditChecklistDialogState extends State<EditChecklistDialog> {
  late TextEditingController _titleController;
  DateTime _selectedDate = DateTime.now();
  late List<TextEditingController> _itemControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.checklist.title);
    _selectedDate = widget.checklist.date;
    _itemControllers = widget.checklist.items
        .map((item) => TextEditingController(text: item.title))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _itemControllers.forEach((controller) => controller.dispose());
    super.dispose();
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
                    initialDateTime: _selectedDate,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
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
    return CupertinoAlertDialog(
      title: Text('Edit Checklist'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoTextField(
              controller: _titleController,
              placeholder: 'Checklist Title',
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                CupertinoButton(
                  child: Icon(Icons.calendar_today),
                  onPressed: () => _showDatePicker(context),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _itemControllers.length + 1,
                itemBuilder: (context, index) {
                  if (index == _itemControllers.length) {
                    return CupertinoButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _itemControllers.add(TextEditingController());
                        });
                      },
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                          controller: _itemControllers[index],
                          placeholder: 'Item ${index + 1}',
                        ),
                      ),
                      CupertinoButton(
                        child: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            _itemControllers.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            final title = _titleController.text;
            final date = _selectedDate;
            final items = _itemControllers
                .map((controller) => ChecklistItem(title: controller.text))
                .toList();
            final updatedChecklist = ChecklistSource(title: title, date: date, items: items);

            Navigator.of(context).pop(updatedChecklist);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}