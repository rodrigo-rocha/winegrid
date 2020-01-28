import 'package:flutter/material.dart';
import 'note_list.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/func/warning.dart';
import 'package:winegrid/api/api_functions.dart';

TextEditingController titleController = new TextEditingController();
TextEditingController bodyController = new TextEditingController();

FocusNode titleFocus = new FocusNode();
FocusNode bodyFocus = new FocusNode();

class NoteContent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteContentState();
  }
}

class NoteContentState extends State<NoteContent> {

  final _editValKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    print(note_body);

    titleController.text = note_title;
    bodyController.text = note_body;

    // TODO: implement build
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: Functions.wineBarCreation(
          "EDIT NOTE", Icons.done,
              () {
            if(titleController.text == "" && bodyController.text == "") {
              Navigator.of(context).pushReplacementNamed('/notes_controller');
            } else {
              titleController.text = ""; bodyController.text = "";
              /// TODO: Maybe go to the unedited list
              FunctionDialogue.confirmationWarning(context, () => Navigator.of(context).pushNamed('/notes_controller'));
            }
          },
              () => setState(() {
                ///TODO: VALIDATE
            //if(_editValKey.currentState.validate()) {
              APIFunctions.callWebServiceForEditingNotes(note_id,titleController.text,bodyController.text);
              titleController.text = ""; bodyController.text = "";
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/notes_controller');
            //}
          })
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            noteTitle(),
            noteBody(),
            helperButtons(),
            //saveEditButtons()
          ],
        ),
      ),
    );
  }

  Widget noteTitle() {
    // First element
    return TextFormField(
      focusNode: titleFocus,
      onFieldSubmitted: (term) {
        titleFocus.unfocus();
        FocusScope.of(context).requestFocus(bodyFocus);
      },
      validator: (val) => val.isEmpty? 'This field can\'t be empty' : null,
      controller: titleController,
      decoration: InputDecoration(
          labelText: 'Title',
          alignLabelWithHint: true,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide(color: Functions.winegridColor()),
          )
      ),
    );
  }

  Widget noteBody() {
    return TextFormField(
      validator: (val) => val.isEmpty? 'This field can\'t be empty' : null,
      focusNode: bodyFocus,
      controller: bodyController,
      maxLines: 7,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
          labelText: 'Description',
          alignLabelWithHint: true,
          border: new UnderlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
              borderSide: BorderSide(color: Functions.winegridColor(),)
          )
      ),
    );
  }

  Widget helperButtons() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.filter), onPressed: () => ""),
                  Text("Add attachment", style: TextStyle(fontSize: 15)),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.cancel),
                    onPressed: () {
                      if(titleFocus.hasFocus) {
                        titleController.text = "";
                      } else {
                        bodyController.text = "";
                      }
                    },),
                  Text("Clear field", style: TextStyle(fontSize: 15)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget saveEditButtons() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Functions.winegridColor(),
              textColor: Colors.white,
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent )),
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () {
                setState(() {
                  // Save
                  APIFunctions.callWebServiceForEditingNotes(note_id,titleController.text,bodyController.text);
                  Navigator.of(context).pushNamed('/notes_controller');
                });
              },
            ),
          ),

          Container(width: 5.0),

          Expanded(
            child: RaisedButton(
              color: Functions.winegridColor(),
              textColor: Colors.white,
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent )),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () {
                setState(() {
                  // Cancel Pressed
                  Navigator.of(context).pushNamed('/notes_controller');
                });
              },
            ),
          ),

        ],
      ),
    );
  }
}