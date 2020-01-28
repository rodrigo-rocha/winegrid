// TODO: Reformat
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/api/api_functions.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

import 'package:winegrid/analysis/data_analysis.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future, Timer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:winegrid/func/functions.dart';

class HomePage extends StatefulWidget{
  @override
  HomePageState createState()=> HomePageState();
}

class HomePageState extends State<HomePage> {

  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  @override
  void initState() {
    super.initState();
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
  }

  double _buttonRadius = 30.0; // 30.0
  double _tilesRadius = 0.0; // 20.0
  Color _shadowColor = Colors.black;
  double _buttonHeight = 100.0;
  double _iconSize = 20.0;
  //Color tileColor = Colors.grey[300];
  //Color bgColor = Colors.white;
  Color tileColor = Colors.transparent;
  Color bgColor = Colors.white;

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      color: Colors.white.withOpacity(1),
      elevation: 3.0, // Relevo dos botões
      borderRadius: BorderRadius.circular(6), // Tiles Border Radius
      shadowColor: _shadowColor,
      child: InkWell
        (
        // Do onTap() if it isn't null, otherwise do print()
          onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
          child: child
      )
    );
  }

  Future<bool> disableReturn() async {
    return false; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context)
  {

    return WillPopScope(
      onWillPop: () => disableReturn(),
      child: Scaffold
        (
          //backgroundColor: Colors.grey[100],
          backgroundColor: Colors.white,

          body: //Container(
            //decoration: BoxDecoration(
              //image: DecorationImage(
                  //image: NetworkImage('https://uncorkt.com/wp-content/uploads/2019/02/WHITE-WINE-POUR.jpg'),
                    //image: NetworkImage('https://live.staticflickr.com/8348/8155413824_9ea62cee70_b.jpg'),
                  //image: NetworkImage('https://ilovewine.com/wp-content/uploads/2018/06/17.-iStock-487552030.jpg'),
                  //colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.srcOver),
                //fit: BoxFit.cover,
              //)
            //),
            //child:
            StaggeredGridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              crossAxisSpacing: 22.0, // Spacing 12?
              mainAxisSpacing: 22.0, // Spacing 12?
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0), // Check horizontal 16? ou 26-26
              children: <Widget>[
                Functions.showLogo(),
                _buildTileImage('QR CODE', 'assets/images/qrlogo.png', () => Navigator.of(context).pushNamed('/qr_scan'), 'https://static.timesofisrael.com/www/uploads/2013/03/F130127YS53.jpg'),
                _buildTileImage('SCAN DEVICES', 'assets/images/scan_bluetooth.png', () => Navigator.of(context).pushNamed('/searchDevice'), 'https://static.timesofisrael.com/www/uploads/2017/08/000_RT7XH-e1503658550227.jpg'),
                _buildTileImage('NOTES', 'assets/images/notes_logo.png', () => Navigator.of(context).pushNamed('/notes_controller'), 'https://www.bordeus-turismo.pt/var/ezwebin_site/storage/images/media/images/vignobles/dans-les-vignes/13912-1-fre-FR/Dans-les-vignes_format_780x490.jpg'),
                _buildTileImage('PROCESSES', 'assets/images/processes_logo.png', () => Navigator.of(context).pushNamed('/process_controller'),'https://3c1703fe8d.site.internapcdn.net/newman/csz/news/800/2018/southafricas.jpg'),
                _buildTileImage('DATA ANALYSIS', 'assets/images/data_analysis.png', () => Navigator.of(context).pushNamed('/density_page'),'https://3c1703fe8d.site.internapcdn.net/newman/csz/news/800/2018/southafricas.jpg'),
                _buildTileImage('LOG OUT', 'assets/images/logout_logo.png', () => _logOut(), 'https://www.alfalaval.com/globalassets/images/media/here-magazine/no36/wine_production_story_640x360.jpg'),

              ],
            staggeredTiles: [
              //StaggeredTile.extent(2, _buttonHeight), // Takes two columns with **110** height
              //StaggeredTile.extent(2, _buttonHeight),
              //StaggeredTile.extent(2, _buttonHeight),
              //StaggeredTile.extent(2, _buttonHeight),
              //StaggeredTile.extent(2, _buttonHeight),
              StaggeredTile.fit(2),
              StaggeredTile.fit(1),
              StaggeredTile.fit(1),
              StaggeredTile.fit(1),
              StaggeredTile.fit(1),
              StaggeredTile.fit(2),
              StaggeredTile.fit(2),
            ],
        ),
      ),
    );
  }

  Widget _buildTileIcon(String title, IconData icon, action()) {
    return _buildTile(
      _tileFormat(title, icon),
      onTap: () =>
      {
        action(),
      }
    );
  }

  Widget _buildTileImage(String title, String path, action(), String image) {
    return Container(
      child: _buildTile(
          _tileFormatImage(title, path),
          onTap: () =>
          {
          action(),
        }
      ),
    );
  }

  Padding _tileFormat(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0))
            ],
          ),
          Material (
            color: Functions.winegridColor(),
            //borderRadius: BorderRadius.circular(_buttonRadius),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(icon, color: Colors.transparent, size: _iconSize),
              )
            )
          )
        ]
      ),
    );
  }

  /*Padding _tileFormatImage(String title, String path) {
    return Padding(
      padding: const EdgeInsets.all(00.0),
      //child:
        //height: 100,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20.0),)
          ]
        ),
    );
  }*/

  Padding _tileFormatImage(String title, String path) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Material (
              //color: Functions.winegridColor(),
                color: tileColor,
                borderRadius: BorderRadius.circular(2),
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset(path, color: Functions.winegridColor(), scale: 3,height: 50,width: 50,),
                      //child: Image.asset(path, color: Colors.black, scale: 3,height: 50,width: 50,),
                    )
                )
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15.0, letterSpacing: 2),)
          ]
      ),
    );
  }

  void _logOut() {
    Alert(
      context: context,
      type: AlertType.error,
      title: "LOG OUT",
      desc: "Are you sure you want to log out?",
      buttons: [
        DialogButton(
          child: Text("LOG OUT", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () =>
          {
            APIFunctions.callWebServiceForLogout(),
            Navigator.of(context).pushNamed('/login'),
          }, // Logs out
          color: Colors.red,
        ),
        DialogButton(
          child: Text("STAY", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => Navigator.pop(context),
          color: Colors.green,
        ),
    ],
    ).show();
  }
}