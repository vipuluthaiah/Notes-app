import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../note.dart';
import '../databasehelper.dart';
import 'note_details.dart';


class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {



  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;



  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO '),
        centerTitle: true,
        elevation: 5.0,
        backgroundColor: Colors.black,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        
          elevation: 0.0,
        backgroundColor: Colors.black,
        
        onPressed: () {
          navigateToDetail(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Tasks',
        child: Icon(Icons.add, color: Colors.white),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ListView getNoteListView() {
    // TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.black,
          elevation: 5.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("https://media.giphy.com/media/RMMkV2n8iiQiIu2p9t/giphy.gif"),
              backgroundColor: Colors.transparent,
              radius: 32.0,
            ),
            title: Text(
              this.noteList[position].title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
            subtitle: Text(
              this.noteList[position].date,
              style: TextStyle(color: Colors.white),
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.remove_circle,
                color: Colors.white,
              ),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
         
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position], 'Edit Things');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
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
      _showSnackBar(context, 'Deleted Successfully.....');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
