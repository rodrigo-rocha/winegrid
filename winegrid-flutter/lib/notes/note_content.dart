import 'package:flutter/material.dart';
import 'note_list.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';

TextEditingController titleController = new TextEditingController();
TextEditingController bodyController = new TextEditingController();

class NoteContent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteContentState();
  }
}

class NoteContentState extends State<NoteContent> {

  @override
  Widget build(BuildContext context) {

    print(note_body);

    titleController.text = note_title;
    bodyController.text = note_body;

    // TODO: implement build
    return Scaffold(

      appBar: Functions.wineBar("EDIT NOTE"),


      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[

            // First element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: TextStyle(
                  fontSize: 30,
                ),
                decoration: InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide(width: 10, color: Colors.black)) ,
                ),
              ),

            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: bodyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
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
            ),
          ],
        ),
      ),
    );
  }
}