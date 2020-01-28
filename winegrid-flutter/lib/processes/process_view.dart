import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/processes/processes_list.dart';
import 'package:winegrid/api/api_functions.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

DateTime procFinishedDate;
DateTime initialTime = DateTime.now();
bool finished;

class ProcessView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return ProcessViewState();
  }
}

class ProcessViewState extends State<ProcessView> {

  void choiceActions(String choice) {
    if(choice == 'Stop') {
      Navigator.of(context).pushNamed('/note_content');
    } else if(choice == 'Delete') {
      print("This");
    }
  }

  Widget popUpButton(){
    return PopupMenuButton<String> (
      onSelected: choiceActions,
      itemBuilder: (BuildContext context) {
        return ['Stop process', 'Delete process'].map((String choice) {
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
    // TODO: implement build
    return Scaffold(
      appBar: Functions.wineBarActions("Process Details", popUpButton()),
      body: ListView(
        children: <Widget>[
          procCont(proc_name, "NAME", Icons.text_fields),
          procCont(proc_processType, "TYPE", Icons.tonality),
          procCont(proc_startedAt, "STARTED AT", Icons.timer),
          procCont(proc_endedAt, "ENDED AT", Icons.timer_off),
          procCont(proc_b.name, "BATCH", Icons.storage),
          procCont(proc_place.name, "PLACE", Icons.place),
          procCont(proc_unit.name, "MONITORED UNIT", Icons.my_location),
          stopButton("STOP PROCESS"),
        ],
      ),
    );
  }



  Widget procCont(String title, String subtitle, IconData icon){
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(0.0),
      shape: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      child: ListTile(
        subtitle: Text(subtitle),
        title: Text(title),
        leading: Icon(icon, size: 30),
      ),
    );
  }

  Widget stopButton(String text) {

    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),

        onPressed: () {
          //confirmationDialogue();
          DatePicker.showDateTimePicker(
            context,
            theme: DatePickerTheme(
              doneStyle: TextStyle(
                color: Colors.green,
              ),
              containerHeight: 300,
            ),
            currentTime: DateTime.now(),
            locale: LocaleType.en, // Dates in English
            showTitleActions: true,
            onConfirm: (date) {
              if(date.compareTo(DateTime.now()) <= 0) {
                _showDialog();
                _showDialog();
              } else {
                procFinishedDate = date;
                confirmationDialogue();
                confirmationDialogue();
                print("---->$date");
              }
            },
          );
        },

        padding: EdgeInsets.all(15),
        color: Functions.winegridColor(),
        child: Text(text,
          style: TextStyle(
              fontSize: 15,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Invalid date picked"),
          content: new Text("Please select a valid date."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void confirmationDialogue() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "STOP PROCESS",
      desc: "Are you sure you want to stop this process?",
      buttons: [
        DialogButton(
          child: Text(
            "STOP",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            APIFunctions.callWebServiceForStoppingProcess(proc_id, procFinishedDate.toString(), ()=> Navigator.of(context).pushNamed('/process_controller'), ()=> showError());
          },
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            "DON'T STOP",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
      ],
    ).show();
  }

  void showError() {
    Alert(
      context: context,
      type: AlertType.error,
      title: "ERROR",
      desc: "Something went wrong. Please try again.",
      buttons: [
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.red,
        ),
      ],
    ).show();
  }

}