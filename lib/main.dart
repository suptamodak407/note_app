import 'package:flutter/material.dart';
import 'package:note_app/utils/database_helper.dart';
import 'models/note.dart';
import 'screen/note_list.dart';
import 'screen/note_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Note> noteList = await DatabaseHelper().getNoteList();
  runApp(MyApp(
    note: noteList,
  ));
}

class MyApp extends StatelessWidget {
  final List<Note>? note;
  const MyApp({required this.note, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoteList(
        noteList: note??[],
      ),
    );
  }
}
