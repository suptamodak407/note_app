import 'package:flutter/material.dart';
import 'dart:async';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBatTitle;
  final Note note;
  NoteDetail({required this.note, required this.appBatTitle});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
  // _NoteDetailState(this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  static var priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.appBatTitle;
    Note note = widget.note;
    titleController.text = note.title ?? "";
    descriptionController.text = note.description ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            ListTile(
              //DropdownButton
              title: DropdownButton(
                  items: priorities.map((String dropDeowStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDeowStringItem,
                      child: Text(dropDeowStringItem),
                    );
                  }).toList(),
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      print('low');
                      updatePriorityAsInt(valueSelectedByUser!);
                    });
                  }),
            ),
            //TextField for Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: titleController,
                // style:,
                onChanged: (value) {
                  print('give title');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    // labelStyle: ,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            //TextField for Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: descriptionController,
                // style:,
                onChanged: (value) {
                  print('give title');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    // labelStyle: ,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            //button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade400,
                      ),
                      onPressed: (() {
                        setState(() {
                          print('save');
                          _save();
                        });
                      }),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade400,
                      ),
                      onPressed: (() {
                        setState(() {
                          print('delete');
                          _delete();
                        });
                      }),
                      child: Text(
                        'Delete',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        widget.note.priority = 1;
        break;
      case 'Low':
        widget.note.priority = 2;
        break;
      default:
    }
  }

  String getPriorityAsString(int value) {
    String? priority;
    switch (value) {
      case 1:
        priority = priorities[0];
        break;
      case 2:
        priority = priorities[1];
        break;
      default:
    }
    return priority!;
  }

  void updateTitle() {
    widget.note.title = titleController.text;
  }

  void updateDescription() {
    widget.note.description = descriptionController.text;
  }

  void _save() async {
    widget.note.date = DateFormat.MMMd().format(DateTime.now());
    int result;
    if (widget.note.id != null) {
      result = await DatabaseHelper().updateNote(widget.note);
    } else {
      result = await DatabaseHelper().insertNote(widget.note);
    }
    if (result != null) {
      _showAlertDialog('Status', 'Note Save Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Save Note');
    }
  }

  void _delete() async {
    if (widget.note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    int result = await DatabaseHelper().deleteNote(widget.note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
