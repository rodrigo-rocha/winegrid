import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';
import 'package:winegrid/classes/Process.dart';
import 'package:winegrid/func/date_format.dart';

import 'package:winegrid/processes/process_controller.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

String fproc_url = "";
String fproc_id = "";
String fproc_name = "";
String fproc_description = "";
String fproc_processType = "";
String fproc_contentType = "";
String fproc_startedAt = "";
String fproc_endedAt = "";
String fproc_createdAt = "";
String fproc_lastActivity = "";

Batch fproc_b;
Place fproc_place;
Unit fproc_unit;

class UnfinishedProcessList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return UnfinishedProcessListState();
  }
}

class UnfinishedProcessListState extends State<UnfinishedProcessList> {

  Future<List<Process>> _getUnfinishedProcesses() async {
    var processData = await APIFunctions.callWebServiceReadingProcesses();

    var jsonData = json.decode(processData.body);
    List<Process> fprocessContent = [];

    for(var n in jsonData['results']) {
      Process fproc = Process(
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

      if(n['ended_at'] != null) {
        fprocessContent.add(fproc);
      }
    }

    return fprocessContent;
  }

  @override
  Widget build(BuildContext context) {

    _getUnfinishedProcesses();


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
            future: _getUnfinishedProcesses(),
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
                      "No finished processes yet",
                      style: TextStyle(
                          fontSize: 20),
                    ),
                  ),
                );
              } else {
                /// TODO: Order by Active Process?
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _processTile(snapshot.data[index].name, snapshot.data[index].processType, snapshot.data, snapshot.data[index].id.toString(),
                          () {
                        print(snapshot.data[index].toString());

                        fproc_url = snapshot.data[index].url.toString();
                        fproc_name = snapshot.data[index].name.toString();
                        fproc_id = snapshot.data[index].id.toString();
                        fproc_startedAt = snapshot.data[index].startedAt.toString();
                        fproc_endedAt = snapshot.data[index].endedAt.toString();
                        fproc_processType = snapshot.data[index].processType.toString();
                        fproc_b = Batch.getBatch(snapshot.data[index].batch);
                        fproc_place = Place.getPlace(snapshot.data[index].units);
                        fproc_unit = Unit.getUnit(snapshot.data[index].units);
                        Navigator.of(context).pushNamed('/finished_process_view');
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

  Widget _processTile(String title, String subtitle, Object process, String procID, actions()) {
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
                Icon(Icons.adjust, color: Colors.red),
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