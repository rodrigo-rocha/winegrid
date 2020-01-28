import 'package:flutter/material.dart';
import 'package:winegrid/ble/connectedDevices.dart';
import 'package:winegrid/ble/qr_scan.dart';
import 'package:winegrid/ble/searchDevice.dart';
import 'package:winegrid/menu/main_menu.dart';
import 'package:winegrid/auth/login.dart';
import 'package:winegrid/auth/signup.dart';
import 'package:winegrid/auth/forget_password.dart';
import 'package:winegrid/notes/note_edit.dart';
import 'package:winegrid/notes/note_list.dart';
import 'package:winegrid/notes/reports_list.dart';
import 'package:winegrid/notes/note_create.dart';
import 'package:winegrid/notes/note_view.dart';
import 'package:winegrid/notes/report_view.dart';
import 'package:winegrid/processes/processes_list.dart';
import 'package:winegrid/processes/process_view.dart';
import 'package:winegrid/processes/finished_process_view.dart';
import 'package:winegrid/processes/stop_process.dart';
import 'package:winegrid/analysis/data_analysis.dart';
import 'package:winegrid/processes/process_controller.dart';
import 'package:winegrid/notes/notes_controller.dart';
import 'package:winegrid/analysis/density_values.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Questrial',
          primarySwatch: Colors.grey
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/connectedDevice' : (BuildContext context) => new FlutterBlueApp(),
        '/qr_scan'         : (BuildContext context) => new QRScan(),
        '/login'           : (BuildContext context) => new Login(),
        '/forgot_password' : (BuildContext context) => new ForgotPassword(),
        '/main_menu'       : (BuildContext context) => new HomePage(),
        '/note_list'       : (BuildContext context) => new NoteList(),
        '/report_list'       : (BuildContext context) => new ReportsList(),
        '/note_detail'     : (BuildContext context) => new NoteDetail(),
        '/note_content'    : (BuildContext context) => new NoteContent(),
        '/report_view'    : (BuildContext context) => new ReportView(),
        '/searchDevice'    : (BuildContext context) => new SearchBlueApp(),
        '/signup'          : (BuildContext context) => new SignupPage(),
        '/note_view'       : (BuildContext context) => new NoteView(),
        '/proc_list'       : (BuildContext context) => new ProcessList(),
        '/proc_view'       : (BuildContext context) => new ProcessView(),
        '/finished_process_view' : (BuildContext context) => new FinishedProcessView(),
        '/proc_stop'       : (BuildContext context) => new StopProcess(),
        '/notes_controller' : (BuildContext context) => new NotesController(),
        '/process_controller' : (BuildContext context) => new ProcessController(),
        '/data_analysis' : (BuildContext context) => new TableLayout(),
        '/density_page' : (BuildContext context) => new DensityValues(),
      },
      home: Login(),
    );
  }
}