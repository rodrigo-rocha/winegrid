import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/processes/processes_list.dart';
import 'package:winegrid/processes/finished_processes_list.dart';

class ProcessController extends StatefulWidget {
  @override
  ProcessControllerState createState() => new ProcessControllerState();
}

class ProcessControllerState extends State<ProcessController> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Processes', textAlign: TextAlign.left ,

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
              Tab(child: Text("Ongoing", style: TextStyle(fontSize: 22.0, color: Functions.winegridColor()))),
              Tab(child: Text("Finished", style: TextStyle(fontSize: 22.0, color: Functions.winegridColor()))),
            ],
          ),
          //title: Text('Notes'),
        ),
        body: TabBarView(
          children: [
            ProcessList(),
            UnfinishedProcessList(),
          ],
        ),
      ),
    );
  }

}