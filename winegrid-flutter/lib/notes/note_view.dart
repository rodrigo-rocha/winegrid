import 'package:flutter/material.dart';
import 'note_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';

TextEditingController titleController = new TextEditingController();
TextEditingController bodyController = new TextEditingController();

String editTitle = titleController.text;
String editbody = bodyController.text;

class NoteView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteViewState();
  }
}
class NoteViewState extends State<NoteView> {

  void choiceActions(String choice) {
    if(choice == 'Edit') {
      Navigator.of(context).pushNamed('/note_content');
    } else if(choice == 'Delete') {
      deleteNoteWarning(note_id);
    }
  }

  Widget popUpButton(){
    return PopupMenuButton<String> (
      onSelected: choiceActions,
      itemBuilder: (BuildContext context) {
        return ['Edit', 'Delete'].map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    //final ap = APIFunctions.callWebServiceForLoginUser('demo10', 'demo10', () => print("Success"), () => print("FAIL"));

    print(note_body);

    titleController.text = note_title;
    bodyController.text = note_body;

    /*
    for(String s in attachments) {
      print(s);
      print("~~~~~~~>>>${APIFunctions.callWebServiceReadingImages(s)}");
    }


    String s = '<p>ABVCDHDH</p> '
        '<p><img src="https://wine.watgrid.com/api/dashboard/notes/files/2018/05/28/chart.ff1d60c4a0804f9fbe91750246f3d437.png"></p>'
        '<p>FINAL</p>';
    */
    // TODO: implement build
    return Scaffold(
      appBar: Functions.wineBarActions('Note Content', popUpButton()),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        child: ListView(
          children: <Widget>[
            noteTitleViewer(),
            noteBodyViewer(),
          ],
        ),
      ),
    );
  }

  Widget noteTitleViewer() {
    return Container(
      height: 30,
      //color: Colors.yellow[100],
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      child: Text(note_title, style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
    );
  }

  Widget noteBodyViewer() {
    return Container(
      height: 300,
      child: HtmlView(
        data: note_body,
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
            print('Note ID: $noteID');
            APIFunctions.callWebServiceForDeletingNotes(noteID);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/notes_controller');
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