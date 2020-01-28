import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';
import 'package:winegrid/classes/Note.dart';
import 'package:winegrid/func/date_format.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

String note_body = "";
String note_title = "";
String note_id = "";
String note_createdAt = "";
final attachments = [];
String note_attachments = "";

class NoteList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  Future<List<Note>> _getNotes() async {
    var notesDate = await APIFunctions.callWebServiceReadingNotes();

    var jsonData = json.decode(notesDate.body);
    print(jsonData);

    List<Note> notesContent = [];

    for(var n in jsonData) {
      Note note = Note(n['id'], n['title'], n['body'], n['attachments'], DateReformat.reformat(n['created_at']),n['is_report']);
      if(!n['is_report']) {
        notesContent.add(note);
      }
    }

    return notesContent;
  }

  @override
  Widget build(BuildContext context) {

    _getNotes();

    // TODO: implement build
    return Scaffold(

      //appBar: Functions.wineBar("Note List"),
      body: RefreshIndicator(
        color: Functions.winegridColor(),
        onRefresh: () {
          _refreshPage();
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
          child: FutureBuilder(
            future: _getNotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null) {
                return Container(
                    child: Center(
                      child: new CircularProgressIndicator(),
                    )
                );
              } else if(snapshot.data.length == 0) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      "No notes yet",
                      style: TextStyle(
                          fontSize: 20),
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _addNoteTile(snapshot.data[index].title, snapshot.data[index].created_at.toString(), snapshot.data, snapshot.data[index].id.toString(),

                      () {
                        // TODO: Abrir Notas e ver conteudo
                        for(String s in snapshot.data[index].attachments) {
                          attachments.add(s);
                          //print("~~~~~~~>>>${APIFunctions.callWebServiceReadingImages(s)}");
                        }
                        note_body = snapshot.data[index].body.toString();
                        note_title = snapshot.data[index].title;
                        note_id = snapshot.data[index].id.toString();
                        note_createdAt = snapshot.data[index].created_at.toString();
                        //note_attachments = snapshot.data[index].attachments.toString();

                        //print('---->>>>>>>>> ${snapshot.data[index].attachments.length}');
                        Navigator.of(context).pushNamed('/note_view');
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add new note',
          backgroundColor: Colors.white,// Functions.winegridColor(),
          child: Icon(Icons.add, color: Functions.winegridColor()),
          onPressed: () {
            // New Note Pressed
            Navigator.of(context).pushNamed('/note_detail');
          }),
    );
  }

  /// onRefresh Function
  Future<void> _refreshPage() async
  {
    Navigator.of(context).pushNamed('/notes_controller');
  }

  Widget _addNoteTile(String title, String subtitle, Object note, String noteID, action ()) {
    return
      Dismissible(
        background: Container(child: Icon(Icons.delete, size: 40, color: Functions.winegridColor())),
        confirmDismiss: (covariant) {
          deleteNoteWarning(noteID);
        },
        key: ObjectKey(note),
        child: Card(
          color: Colors.transparent,
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.5,
                color: Colors.grey,
              )
          ),
          child: ListTile(
            onTap: () {
              action ();
            },

            title: Text(title, style: TextStyle(fontSize: 20),),
            //leading: Icon(Icons.account_circle, size: 50,), ///Change for pic
            subtitle: Text(subtitle),
            trailing: Icon(Icons.delete_sweep, color: Functions.winegridColor()),
          ),
          elevation: 0.0,
        ),
      );
  }

  /// ALERT DIALOGUES
  void deleteNoteWarning(String noteID) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "DELETE NOTE",
      desc: "Are you sure you want to delete this note?",
      buttons: [
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            print('Note ID: $noteID');
            APIFunctions.callWebServiceForDeletingNotes(noteID);
          },
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            "Don't Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.green,
        ),
      ],
    ).show();
  }
}