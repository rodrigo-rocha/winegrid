import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:winegrid/func/functions.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'dart:async' show Future, Timer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:math' as math;


class DensityValues extends StatefulWidget {
  List<double> den = [0.0 ,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0];
  @override
  DensityValuesState createState() => new DensityValuesState();
}

class DensityValuesState extends State<DensityValues> {

  Map<String, double> dataMap = new Map();

  math.Random random = new math.Random();

  List<double> _generateRandomData(int count) {
    List<double> result = <double>[];
    for (int i = 0; i < count; i++) {
      result.add(random.nextDouble() * 100);
    }
    return result;
  }

  List<double> _generateRandomData1(int count, List<double> values) {
    List<double> result = <double>[];
    for(int i = 0; i < values.length; i++) {
      result.add(values[i]);
    }

    return result;
  }

  Color confColor() {
    int min = 1;
    int max = 5;
    int selection = min + (Random(1).nextInt(max-min));

    if(selection != 1) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  List<List<dynamic>> data = [];
  List<List<dynamic>> dataTemp = [];
  List<List<dynamic>> confidence = [];

  loadAsset() async {
    final myData = await rootBundle.loadString("assets/files/set069.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData,eol:'\n');

    data = csvTable;
  }

  loadAssetTemp() async {
    final myDataTemp = await rootBundle.loadString("assets/files/set069.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myDataTemp,eol:'\n');
    dataTemp = csvTable;
  }

  loadConfidenceBand() async {
    final myConfidence = await rootBundle.loadString("assets/files/lupper.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myConfidence,eol:'\n');

    confidence = csvTable;
  }
  makeConfidence(){
    List<List<dynamic>> csvTable = new List(data.length);
    for(int i =1; i<confidence.length;i+=2){
      csvTable[i]=([confidence[0][i-1],confidence[0][i]]);
    }
    confidence = csvTable;
  }

  int _now = 1;
  Timer _everySecond;
  //static List<double> widget.den = [0.0 ,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0];

  @override
  void initState() {
    super.initState();

    // sets first value
    _now = 12;

    _everySecond = Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
      setState(() {

        _now += 1;
        if(_now == data.length-1) {
          t.cancel();
        }
      });
    });
  }

  static List<double> graph(List<double> li, double val)  {
    List<double> result = <double>[];
    for (int i = 0; i < li.length-1; i++) {
      result.add(li[i+1]);
      if(li.length-2 == i){
        result.add(val);
      }
    }
    print(result);
    return result;
  }

  static List<double> graphTime(List<double> li, double val)  {
    List<double> result1 = new List();
    for (int i = 0; i < li.length-1; i++) {
      result1.add(li[i+1]);
      if(li.length-2 == i){
        result1.add(val);
      }
    }
    print(result1);
    return result1;
  }

  static List<double> graphTemp(List<double> li, double val)  {
    List<double> result = <double>[];
    for (int i = 0; i < li.length-1; i++) {
      result.add(li[i+1]);
      if(li.length-2 == i){
        result.add(val);
      }
    }
    print(result);
    return result;
  }

  //List<double> den = new List();

  //TODO: BANDA DE CONFIDÊNCIA

  List<double> lowerConf = new List();
  List<double> upperConf = new List();

  //TODO:FIM DE BANDA DE CONFIDÊNCIA
  static List<double> d1 = [0.1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  static List<double> timestamps = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  static List<double> d2 = [0.1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  static List<double> Cl = [0.1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  static List<double> CH = [0.1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

  static var _doneInitialize = false;
  static var _done = false;
  var _done_initialize = false;
  @override
  Widget build(BuildContext context) {
    if(!_done) {
      loadAsset();
      loadAssetTemp();
      loadConfidenceBand();

      _done = true;
    }

    if(_now < data.length && _now > 0) {

      if(!_done_initialize){
        d1 = [data[1][1],data[2][1],data[3][1],data[4][1],data[6][1],data[7][1],data[8][1],data[9][1],data[10][1],data[11][1]];
        d2 = [data[1][2],data[2][2],data[3][2],data[4][2],data[6][2],data[7][2],data[8][2],data[9][2],data[10][2],data[11][2]];
        CH= [confidence[1][1],confidence[2][1],confidence[3][1],confidence[4][1],confidence[6][1],confidence[7][1],confidence[8][1],confidence[9][1],confidence[10][1],confidence[11][1]];
        Cl= [confidence[1][0],confidence[2][0],confidence[3][0],confidence[4][0],confidence[6][0],confidence[7][0],confidence[8][0],confidence[9][0],confidence[10][0],confidence[11][0]];
        _done_initialize=true;
      }
      d1 = graph(d1,data[_now][1]);
      d2 = graph(d2,data[_now][2]);
      Cl = graph(Cl,confidence[_now][0]);
      CH = graph(CH,confidence[_now][1]);

      return new Scaffold(
        appBar: Functions.wineBar("Device Info"),
        body:

        Center(
          child:
          ListView(padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            children: <Widget>[

              Container(
                decoration: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.grey[600],
                    width: 0.1
                  )
                ),
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 60.0,
                      child: Image.asset('assets/images/barrel_ble.png', fit: BoxFit.scaleDown),
                    ),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Density Sensor", textAlign: TextAlign.left,style: TextStyle(fontSize: 25)),
                      ],
                    )
                  ],
                ),
              ),
              _charTile("Temperature", dataTemp[_now][2], 'assets/images/temp1.png', ' ºC'),
              _charTile("Density",  data[_now][1],'assets/images/density.png', ' g/cm³'),
              SizedBox(height: 40),
              Text("Density Data (g/cm³)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),textAlign: TextAlign.center,),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 200,
                  width:  200,
                  child: new charts.LineChart(_createSampleData3(data[_now][1], confidence[_now][0],confidence[_now][1]),
                    animate: true,
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                      tickProviderSpec:
                      new charts.BasicNumericTickProviderSpec(zeroBound: false, dataIsInWholeNumbers: false)
                    )
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Temperature Data (ºC)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),textAlign: TextAlign.center,),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 200,
                  width:  200,
                  child: new charts.LineChart(_createSampleData2(data[_now][2]),
                    animate: true,
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                      tickProviderSpec:
                      new charts.BasicNumericTickProviderSpec(zeroBound: false, dataIsInWholeNumbers: false)
                    )
                  ),

                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      );
    }  else {
      return new Scaffold(
        appBar: Functions.wineBar("Device Info"),
        body:

        Center(
          child:
          ListView(padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            children: <Widget>[
              //Center(child: Text("Connected to: $result")),

              Container(
                decoration: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        color: Colors.grey[600],
                        width: 0.1
                      //color: Functions.winegridColor(),
                    )
                ),
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      //backgroundImage: AssetImage('assets/images/barrel.png'),
                      radius: 60.0,
                      child: Image.asset('assets/images/barrel_ble.png', fit: BoxFit.scaleDown),
                    ),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Density Sensor", textAlign: TextAlign.left,style: TextStyle(fontSize: 25)),
                        //Text("ON", textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                      ],
                    )
                  ],
                ),
              ),

              _charTile("Temperature", 0.0, 'assets/images/temp1.png', ' ºC'),
              _charTile("Density",  0.0,'assets/images/density.png', ' g/cm³'),
              SizedBox(height: 20),
            ],
          ),
        ),

        /*floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.refresh),
          backgroundColor: _winegridColor(),
          label: Text("Refresh"),
          onPressed: _refreshAll,
        ), */


        //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }


  }

  Widget _charTile(String charName, double value, String img, String units) {
    return new Card(
      elevation: 0.0,
      color: Colors.transparent,
      shape: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.2,
          )
      ),
      child: ListTile(
        leading: CircleAvatar(child: Image.asset(img, color: Functions.winegridColor()),backgroundColor: Colors.transparent),
        title: Row(
          children: <Widget>[
            Text(value.toString(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),

            ),
            Text(units)
          ],
        ),
        subtitle: Text(charName),
        //onTap: () {
        //  _showDialog();
        //},
      ),
    );
  }

  Widget _charTileString(String charName, String img, String units, String vls) {
    return new Card(
      elevation: 0.0,
      color: Colors.transparent,
      shape: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.2,
          )
      ),
      child: ListTile(
        leading: CircleAvatar(child: Image.asset(img, color: Functions.winegridColor()),backgroundColor: Colors.transparent),
        title: Row(
          children: <Widget>[
            Text(vls,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),

            ),
            Text(units)
          ],
        ),
        subtitle: Text(charName),
        //onTap: () {
        //  _showDialog();
        //},
      ),
    );
  }

  Widget _charTileTimestamp(String charName, int value, String img, String units) {

    return new Card(
      elevation: 0.0,
      color: Colors.transparent,
      shape: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.2,
          )
      ),
      child: ListTile(
        leading: CircleAvatar(child: Image.asset(img, color: Functions.winegridColor()),backgroundColor: Colors.transparent),
        title: Row(
          children: <Widget>[
            //Text(DateTime.fromMillisecondsSinceEpoch('0).toString(),
              //style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),

            //),
            Text(units)
          ],
        ),
        subtitle: Text(charName),
        //onTap: () {
        //  _showDialog();
        //},
      ),
    );
  }

    Color _winegridColor() {
    return new Color(0xffa32942);
  }

  static List<charts.Series<LinearData, double>> _createSampleData2(value) {
    var temp = graphTemp(d2,double.parse(value.toStringAsFixed(3)));
    //var timestp = graphTime(timestamps,value.toDouble());
    final data = [
      new LinearData(0, temp[0]),
      new LinearData(1, temp[1]),
      new LinearData(2, temp[2]),
      new LinearData(3, temp[3]),
      new LinearData(4, temp[4]),
      new LinearData(5, temp[5]),
      new LinearData(6, temp[6]),
      new LinearData(7, temp[7]),
      new LinearData(8, temp[8]),
      new LinearData(9, temp[9]),
    ];

    return [
      new charts.Series<LinearData, double>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearData sales, _) => sales.index,
        measureFn: (LinearData sales, _) => sales.temp,
        //measureLowerBoundFn: (LinearData sales, _) => (sales.temp - 0.5),
        //measureUpperBoundFn: (LinearData sales, _) => (sales.temp + 0.5),
        data: data,
      )
    ];
  }

  static List<charts.Series<LinearDensity, double>> _createSampleData3(value, conf_now_L,conf_now_H) {
    var res = graphTemp(d1,double.parse(value.toStringAsFixed(3)));
    var confL = graph(Cl,conf_now_L);
    var confH = graph(CH,conf_now_H);
    //var timestp = graphTime(timestamps,timestamp.toDouble());
    final data = [
      new LinearDensity(0, res[0], confL[0], confH[0]),
      new LinearDensity(1, res[1], confL[1], confH[1]),
      new LinearDensity(2, res[2], confL[2], confH[2]),
      new LinearDensity(3, res[3], confL[3], confH[3]),
      new LinearDensity(4, res[4], confL[4], confH[4]),
      new LinearDensity(5, res[5], confL[5], confH[5]),
      new LinearDensity(6, res[6], confL[6], confH[6]),
      new LinearDensity(7, res[7], confL[7], confH[7]),
      new LinearDensity(8, res[8], confL[8], confH[8]),
      new LinearDensity(9, res[9], confL[9], confH[9]),
    ];

    return [
      new charts.Series<LinearDensity, double>(
        id: 'Liquid Level',
        colorFn: (LinearDensity vals, __) => checkInside(vals.density,vals.confL,vals.confH),
        domainFn: (LinearDensity sales, _) => sales.index,
        measureFn: (LinearDensity sales, _) => sales.density,
        measureLowerBoundFn: (LinearDensity sales, _) => (sales.confL),
        measureUpperBoundFn: (LinearDensity sales, _) => (sales.confH),
        data: data,

      )
    ];
  }
  static int clock = 0;
  static charts.Color checkInside(var dens, var confL, var confH){
    if(confL < dens && confH > dens && clock <= 0){
      return charts.MaterialPalette.cyan.shadeDefault;
    }
    else if(confL < dens && confH > dens && clock > 0){
      clock-=1;
      return charts.MaterialPalette.red.shadeDefault;
    }
    else if(clock>=0 && !(confL < dens && confH > dens ) ){
      clock = 9;
      return charts.MaterialPalette.red.shadeDefault;
    }
    else{
      clock = 9;
      return charts.MaterialPalette.red.shadeDefault;
    }
  }

}


class LinearData {
  final double index;
  final double temp;

  LinearData(this.index, this.temp);
}

class LinearDensity {
  final double index;
  final double density;
  final double confL;
  final double confH;

  LinearDensity(this.index, this.density, this.confL, this.confH);
}
