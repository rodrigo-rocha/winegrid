import 'package:flutter/material.dart';

class Functions {

  /// Show Logo (Hero Function)
  static Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 50.0,
          child: Image.asset('assets/images/winegrid-header-logo.png'),
        ),
      ),
    );
  }

  static AppBar wineBarCreation(String title, IconData icon, unDoAction(), doneAction()) {
    return new AppBar
      (
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(title, textAlign: TextAlign.left ,
        style: TextStyle(
            fontSize: 25.0,
            //fontWeight: FontWeight.bold,
            color: Color(0xffa32942)
        ),
      ),
      elevation: 0.5, // 2
      iconTheme: IconThemeData(
        color: Colors.grey, //change your color here
      ),
      //centerTitle: true,


      leading: IconButton(icon: Icon(Icons.clear), onPressed: () => unDoAction()),
      actions: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
          child: IconButton(icon: Icon(icon, size: 30,),onPressed: () => doneAction()),
          //Image.asset('assets/images/winegrid-small-logo.png'),
        ),
      ],
    );
  }

  /// App Bar
  static AppBar wineBar(String title) {
    return new AppBar
      (
      centerTitle: true,
      title: Text(title, textAlign: TextAlign.center ,
        style: TextStyle(
            fontSize: 25.0,
            //fontFamily: 'Inconsolata',
            //fontWeight: FontWeight.bold,
            color: Color(0xffa32942)
        ),
      ),
      elevation: 0.5, // 2
      iconTheme: IconThemeData(
        color: Colors.grey, //change your color here
      ),
      //centerTitle: true,
      backgroundColor: Colors.white,
      actions: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 15.0),
          child: Image.asset('assets/images/winegrid-small-logo.png',color: Functions.winegridColor()),
        ),
      ],
    );
  }

  static AppBar wineBarActions(String title, Widget popUpButton) {
    return new AppBar
      (
      centerTitle: true,
      title: Text(title, textAlign: TextAlign.center ,
        style: TextStyle(
            fontSize: 25.0,
            color: Color(0xffa32942)
        ),
      ),
      elevation: 0.5, // 2
      iconTheme: IconThemeData(
        color: Colors.grey, //change your color here
      ),
      //centerTitle: true,
      backgroundColor: Colors.white,
      actions: <Widget>[
        popUpButton,
      ],
    );
  }

  static Color winegridColor() {
    return new Color(0xffa32942);
  }

  static void showBluetoothAdapterInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Center(
          child: AlertDialog(
            title: new Text("Bluetooth adapter is turned off", style: TextStyle(color: Functions.winegridColor()),),
            content: Text("Please turn on your bluetooth adapter"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close", style: TextStyle(fontSize: 18, color: Functions.winegridColor())),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
