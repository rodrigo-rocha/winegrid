import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/processes/finished_processes_list.dart';
import 'package:winegrid/api/api_functions.dart';

class FinishedProcessView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return FinishedProcessViewState();
  }
}

class FinishedProcessViewState extends State<FinishedProcessView> {

  void choiceActions(String choice) {
    if(choice == 'Remove from list') {
      print("Remove from this list.");
    } else if(choice == 'See process run') {
      print("See Proc Run");
    }
  }

  Widget popUpButton(){
    return PopupMenuButton<String> (
      onSelected: choiceActions,
      itemBuilder: (BuildContext context) {
        return ['See process run', 'Delete process'].map((String choice) {
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
          procCont(fproc_name, "NAME", Icons.text_fields),
          procCont(fproc_processType, "TYPE", Icons.tonality),
          procCont(fproc_startedAt, "STARTED AT", Icons.timer),
          procCont(fproc_endedAt, "ENDED AT", Icons.timer_off),
          procCont(fproc_b.name, "BATCH", Icons.storage),
          procCont(fproc_place.name, "PLACE", Icons.place),
          procCont(fproc_unit.name, "MONITORED UNIT", Icons.my_location),
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
}