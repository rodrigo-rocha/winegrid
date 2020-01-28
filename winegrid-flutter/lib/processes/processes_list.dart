import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';
import 'package:winegrid/classes/Process.dart';
import 'package:winegrid/func/date_format.dart';

import 'dart:convert' show utf8;

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

String proc_url = "";
String proc_id = "";
String proc_name = "";
String proc_description = "";
String proc_processType = "";
String proc_contentType = "";
String proc_startedAt = "";
String proc_endedAt = "";
String proc_createdAt = "";
String proc_lastActivity = "";

Batch proc_b;
Place proc_place;
Unit proc_unit;

class ProcessList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return ProcessListState();
  }
}

class ProcessListState extends State<ProcessList> {

  Future<List<Process>> _getProcesses() async {
    var processData = await APIFunctions.callWebServiceReadingProcesses();

    var jsonData = json.decode(processData.body);
    List<Process> processContent = [];

    for(var n in jsonData['results']) {
      Process proc = Process(
          n['url'],
          n['id'],
          n['name'],
          n['description'],
          n['process_type'],
          n['content_type'],
          DateReformat.reformat(n['started_at']),
          DateReformat.reformat(n['ended_at']),
          DateReformat.reformat(n['created_at']),
          DateReformat.reformat(n['last_activity']),
          n['batch'],
          n['units']
      );

      if(n['ended_at'] == null) {
        processContent.add(proc);
      }
    }

    return processContent;
  }

  @override
  Widget build(BuildContext context) {

    _getProcesses();

    // TODO: implement build
    return Scaffold(

      //appBar: Functions.wineBar("PROCESS LIST"),
      body: RefreshIndicator(
        color: Functions.winegridColor(),
        onRefresh: () {
          _refreshPage();
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
          child: FutureBuilder(
            future: _getProcesses(),
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
                      "No ongoing processes yet",
                      style: TextStyle(
                          fontSize: 20),
                    ),
                  ),
                );
              } else {
                /// TODO: Order by Active Process?
                //print("ººººº${snapshot.data[0].name}");
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _addNoteTile(snapshot.data[index].name, snapshot.data[index].processType, snapshot.data, snapshot.data[index].id.toString(),
                      () {
                        // TODO: Abrir Notas e ver conteudo
                        proc_url = snapshot.data[index].url.toString();
                        proc_name = snapshot.data[index].name.toString();
                        proc_id = snapshot.data[index].id.toString();
                        proc_startedAt = snapshot.data[index].startedAt.toString();
                        proc_endedAt = snapshot.data[index].endedAt.toString();
                        proc_processType = snapshot.data[index].processType.toString();
                        proc_b = Batch.getBatch(snapshot.data[index].batch);
                        proc_place = Place.getPlace(snapshot.data[index].units);
                        proc_unit = Unit.getUnit(snapshot.data[index].units);
                        Navigator.of(context).pushNamed('/proc_view');
                      },

                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  /// onRefresh Function
  Future<void> _refreshPage() async
  {
    Navigator.of(context).pushNamed('/process_controller');
  }

  Widget _addNoteTile(String title, String subtitle, Object process, String procID, actions()) {
    return
      Card(
          color: Colors.transparent,
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 0.5,
                color: Colors.grey,
              )
          ),
          child: ListTile(
            onTap: () {
              actions();
            },

            title: Text(title, style: TextStyle(fontSize: 20),),
            //leading: Icon(Icons.account_circle, size: 50,), ///Change for pic
            subtitle: Text(subtitle.toUpperCase()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.adjust, color: Colors.green),
              ],
            ),
          ),
          elevation: 0.0,
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