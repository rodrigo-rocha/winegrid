import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';

class NoteDetail extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState();
  }
}

class NoteDetailState extends State<NoteDetail> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    //callWebServiceForLoginUser('demo.pei', 'demo.pei');

    return Scaffold(
      appBar: Functions.wineBar("Note Content"),

      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[

            SizedBox(height: 20,),
            // First element
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                //cursorColor: Colors.black,
                controller: titleController,
                onChanged: (value) {
                  // Debug
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Functions.winegridColor()),
                    )
                ),
              ),
            ),

            // Third Element
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(

                controller: descriptionController,
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                },
                decoration: InputDecoration(
                    fillColor: Functions.winegridColor(),
                    labelText: 'Description',
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Functions.winegridColor(),)
                    )
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
                          APIFunctions.callWebServiceForCreateNote(titleController.text, descriptionController.text);
                          print(titleController.text);
                          print(descriptionController.text);
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

