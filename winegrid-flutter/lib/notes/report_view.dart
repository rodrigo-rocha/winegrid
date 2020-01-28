import 'package:flutter/material.dart';
import 'note_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';
import 'package:winegrid/notes/reports_list.dart';

TextEditingController titleController = new TextEditingController();
TextEditingController bodyController = new TextEditingController();

String editTitle = titleController.text;
String editbody = bodyController.text;

class ReportView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return ReportViewState();
  }
}
class ReportViewState extends State<ReportView> {

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

    titleController.text = rnote_title;
    bodyController.text = rnote_body;

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
      child: Text(rnote_title, style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
    );
  }

  Widget noteBodyViewer() {
    return Container(
      height: 300,
      //color: Colors.yellow[100],
      //decoration: ShapeDecoration(
        //shape: UnderlineInputBorder(
        //  borderRadius: BorderRadius.circular(1.0),
        //  borderSide: BorderSide(color: Colors.grey),
        //),
      //),
      //decoration: BoxDecoration(borderRadius: BorderRadius.circular( 7.0)) ,
      //color: Colors.grey[300],
      child: HtmlView(
        data: rnote_body,
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
            Navigator.of(context).pushNamed('/note_list');
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

  //make the drop down its own widget for readability
  Widget dropdownWidget() {
    String dropdownValue = 'One';

    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}