import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future, Timer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sparkline/flutter_sparkline.dart';

class TableLayout extends StatefulWidget {
  @override
  _TableLayoutState createState() => _TableLayoutState();
}

class _TableLayoutState extends State<TableLayout> {
  List<List<dynamic>> data = [];

  loadAsset() async {
    final myData = await rootBundle.loadString("assets/files/set069.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);

    data = csvTable;
  }
  var _sequence = [10, 10, 8];

  //@override
  //void initState() {
    //super.initState();
    //startTimer(0);
  //}

  int _now;
  Timer _everySecond;

  @override
  void initState() {
    super.initState();
    // sets first value
    _now = 0;

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _now += 1;

        if(_now == data.length) {
          t.cancel();
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    loadAsset();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () async {
            await loadAsset();
            print(data[2]);
            for(int i = 0; i < data.length; i++) {
              print(data[i][1]);
            }
          }),
      appBar: AppBar(
        title: Text("Table Layout and CSV"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Counter',
            ),
            new Text(data[_now][1].toString()),
            Sparkline(
              data: [1.0, 2.0],
              //data: _generateRandomData(10),
              //data: _generateRandomData(10),
              lineColor: Colors.lightGreen[500],
              fillMode: FillMode.below,
              fillColor: Colors.lightGreen[200],
              pointsMode: PointsMode.all,
              pointSize: 5.0,
              pointColor: Colors.amber,
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}