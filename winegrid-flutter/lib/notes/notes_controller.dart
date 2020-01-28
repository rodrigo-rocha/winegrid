import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/notes/note_list.dart';
import 'package:winegrid/notes/reports_list.dart';

class NotesController extends StatefulWidget {
  @override
  NotesControllerState createState() => new NotesControllerState();
}

class NotesControllerState extends State<NotesController> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Notes', textAlign: TextAlign.left ,

            style: TextStyle(
                fontSize: 30.0,
                //fontWeight: FontWeight.bold,
                color: Color(0xffa32942)
            ),
          ),
          elevation: 0.5, // 2
          iconTheme: IconThemeData(
            color: Colors.grey, //change your color here
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Functions.winegridColor(),
            labelColor: Functions.winegridColor(),
            tabs: [
              Tab(child: Text("Notes", style: TextStyle(fontSize: 22.0, color: Functions.winegridColor()))),
              Tab(child: Text("Reports", style: TextStyle(fontSize: 22.0, color: Functions.winegridColor()))),
            ],
          ),
          //title: Text('Notes'),
        ),
        body: TabBarView(
          children: [
            NoteList(),
            ReportsList(),
          ],
        ),
      ),
    );
  }

}