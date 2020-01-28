import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/func/warning.dart';
import 'package:winegrid/api/api_functions.dart';

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

FocusNode titleFocus = new FocusNode();
FocusNode bodyFocus = new FocusNode();

class NoteDetail extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState();
  }
}

class NoteDetailState extends State<NoteDetail> {

  final _validationKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Functions.wineBarCreation(
          "Create Note", Icons.done,
          () {
              if(titleController.text == "" && descriptionController.text == "") {
                Navigator.of(context).pushReplacementNamed('/notes_controller');
              } else {

                /// TODO: Fix bug: Controllers going null when pressed exit (Don't Leave button)
                FunctionDialogue.confirmationWarning(context,
                  () {
                    Navigator.of(context).pushReplacementNamed('/notes_controller');
                  }
                );
              }
            },
          () => setState(() {
            if(_validationKey.currentState.validate()) {
              APIFunctions.callWebServiceForCreateNote(titleController.text, descriptionController.text);
              titleController.text = ""; descriptionController.text = "";
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/notes_controller');
            }
          })
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 1.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            noteView(),
            helperButtons()
            //editSaveButton(),
          ],
        ),
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
                        descriptionController.text = "";
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

  Widget noteView() {
    return Form(
      key: _validationKey,
      child: Column(
        children: <Widget>[
          noteTitleView(),
          SizedBox(height: 15),
          noteBodyView(),
        ],
      ),
    );
  }

  Widget noteTitleView() {
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

  Widget noteBodyView() {
    return TextFormField(
      validator: (val) => val.isEmpty? 'This field can\'t be empty' : null,
      focusNode: bodyFocus,
      controller: descriptionController,
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
}

