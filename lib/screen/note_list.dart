import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:note_app/screen/note_detail.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class NoteList extends StatefulWidget {
  List<Note> noteList;

  NoteList({super.key, required this.noteList});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;
// @override
//   void initState() {
//     if (widget.noteList == null) {
//       widget.noteList = <Note>[];
//       updateListView();
//     }
//     // TODO: implement initState
//     super.initState();
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('button pressed');
          navigateToDetail(Note('', '', 2), 'Add Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(widget.noteList[position].priority),
              child: getPriorityIcon(widget.noteList[position].priority),
            ),
            title: Text(widget.noteList[position].title),
            subtitle: Text(widget.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                _delete(context, widget.noteList[position]);
              },
            ),
            onTap: () {
              print('yes');
              navigateToDetail(widget.noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.shade100;
        break;
      case 2:
        return Colors.green.shade200;
      default:
        return Colors.yellow.shade200;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfilly');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note: note, appBatTitle: title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((Database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          widget.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
