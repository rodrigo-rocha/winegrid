import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';
import 'package:winegrid/processes/processes_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

TextEditingController dateController = new TextEditingController();
TextEditingController timeController = new TextEditingController();

class StopProcess extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return StopProcessState();
  }
}

class StopProcessState extends State<StopProcess> {

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _newDateTime = new DateTime.now();

  // TODO: Verification: Hora menor que hora do primeiro dia

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _date,
      lastDate: new DateTime(2025),
    );

    if(picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Functions.wineBarCreation('Stop Process', Icons.add, () => print("UNDO"), ()=> print("DO")),
      body: Center(
        //padding: EdgeInsets.all(32.0),
        child: new Column(
          children: <Widget> [
            SizedBox(height: 20),
            new Text('Date Selected: ${_date.toString()}'),
            new RaisedButton(
              child: Text("Select Date"),
              onPressed: () {
                _selectDate(context);
              }
            ),
            SizedBox(height: 20),
            new Text('Time Selected: ${_time.toString()}'),
            new RaisedButton(
              child: Text("Select Time"),
              onPressed: () {
                _selectTime(context);
              }
            ),
            SizedBox(height: 20),
            new RaisedButton(
                child: Text("STOP PROCESS"),
                color: Functions.winegridColor(),
                onPressed: () {
                  setState(() {
                    _newDateTime = _newDateTime = new DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
                  });
                  confirmationDialogue();
                }
            )
          ]

        ),
      )
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
            APIFunctions.callWebServiceForStoppingProcess(proc_id, _newDateTime.toIso8601String(), ()=> Navigator.of(context).pushNamed('/proc_list'), ()=> showError());
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