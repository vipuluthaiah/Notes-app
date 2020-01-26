import 'package:flutter/material.dart';
import '../databasehelper.dart';
import '../note.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
final String appbarTitle;
final Note note;

NoteDetail(this.note,this.appbarTitle);

@override
State<StatefulWidget> createState(){
  return NoteDetailState(this.note,this.appbarTitle);
}
}

class NoteDetailState extends State<NoteDetail> {
  static var _priority = ['High','Low'];
  DatabaseHelper helper = DatabaseHelper();
  String appbarTitle;
  Note note;


TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

NoteDetailState(this.note,this.appbarTitle); 


  @override
  Widget build (BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
titleController.text = note.title;
titleController.text =note.description;

return WillPopScope(
  onWillPop: () {
    moveToLastScreen();
    return ;
  },
  child: Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text(appbarTitle),
      backgroundColor: Colors.black54,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          moveToLastScreen();
        },
      ),
    ),
    body: Padding(
            padding: EdgeInsets.only(bottom:11.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                    //dropdown menu
                    child: new ListTile(
                      leading: const Icon(Icons.low_priority),
                      title: DropdownButton(
                          items: _priority.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            );
                          }).toList(),
                           style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          value: getPriorityAsString(note.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                  ),
                  // Second Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                        debugPrint('Something changed in Title Text Field');

                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        icon: Icon(Icons.title),
                      ),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                           debugPrint(
                            'Something changed in Description Text Field');
                        updateDescription();
                        
                      },
                      decoration: InputDecoration(
                        labelText: 'Details',
                        icon: Icon(Icons.details),
                      ),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                // debugPrint("Save button clicked");
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
  ),
);
  }


  
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle(){
    note.title = titleController.text;
  }

    void updateDescription(){
    note.description = descriptionController.text;
  }

void _save()async{
  moveToLastScreen();
  note.date = DateFormat.yMMMd().format(DateTime.now());

  int result;
  if (note.id != null) {
    result = await helper.updateNote(note);
  }else{
    result = await helper.insertNote(note);
  }

  if (result !=0) {
    _showAlertDialog('STATUS', 'Note Saved Successfully');
  }else{
    _showAlertDialog('STATUS', 'Problem Saving Note');
  }


}

void _delete()async{
  moveToLastScreen();
if (note.id == null) {
     _showAlertDialog('STATUS', 'First Add A Note');
    return;
}
 int result = await helper.deleteNote(note.id);
 
  if (result !=0) {
    _showAlertDialog('STATUS', 'Note Deleted Successfully');
  }else{
    _showAlertDialog('STATUS', 'Problem Deleting Note');
  }
}

void updatePriorityAsInt(String value){
switch (value) {
  case 'High':
    note.priority =1;
    break;
      case 'Low':
    note.priority =2;
    break;
}
}
//convert int to String to show user 
String getPriorityAsString(int value){
  String priority;
  switch (value) {
    case 1:
      priority  = _priority[0];
      break;
         case 2:
      priority  = _priority[1];
      break;
  }
  return priority;
}




  void _showAlertDialog(String title,String message){
    AlertDialog alertDialog =AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,builder: (_)=> alertDialog);
  }
}