// TODO: verificação do bluetooth ligado
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:winegrid/func/functions.dart';

import 'qr_scan.dart';

class FlutterBlueApp extends StatefulWidget {
  FlutterBlueApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlutterBlueAppState createState() => new _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
   List<charts.Series> seriesList;
   bool animate;

  static String result = "Unkown";
  static var qrResult = QRScanState.result;


  //Sensor Charactheristics
  var pinHash = "";
  var secret = "0";
  var b = 2;
  var sensor1 = "0";
  var sensor2 = "0";
  var prime1 = "0";
  var prime2 = "0";
  var publicServer = "0";
  var publicClient = "0";
  var _done = false;
  var _doneRead = false;
  var _doneScan = false;
  var _prim1 = false;
  var _prim2 = false;
  var _public = false;
  var time="0";
  static var timestamp=0;
  static var llv=0.0;
  static var temperature=0.0;
  var bat=0.0;

  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  String batIndicator = 'assets/images/bat0.png';
  Color batColor = Colors.black;

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

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }

  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
      /*withServices: [
          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
        ]*/
    )
        .listen((scanResult) {
      //print('localName: ${scanResult.advertisementData.localName}');
      //print('manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      //print('serviceData: ${scanResult.advertisementData.serviceData}');
      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
      null,
      onDone: _disconnect,
    );

    // Update the connection state immediately
    device.state.then((s) {
      setState(() {
        deviceState = s;
      });
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      setState(() {
        deviceState = s;
      });
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          setState(() {
            services = s;
          });
        });
      }
    });
  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    setState(() {
      device = null;
    });
  }


  bool containsResult(var value){
    if(value.advertisementData.localName == qrResult){
      return true;
    }
    else
    {
      return false;
    }
  }


  static List<double> d1 = [0.1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
   static List<double> timestamps = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  static List<double> d2 = [0.1,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  static var _doneInitialize = false;

  static List<double> graph(List<double> li, double val)  {
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
  static List<double> graphTemp(List<double> li2, double val)  {
    List<double> result2 = new List();
    for (int i = 0; i < li2.length-1; i++) {
      result2.add(li2[i+1]);
      if(li2.length-2 == i){
        result2.add(val);
      }
    }
    print(result2);
    return result2;
  }

  void readC(BluetoothService s) async{

    //TODO READ VALUES
    //print("GO HERE");
    for (BluetoothCharacteristic c in s.characteristics) {
      if (c.uuid.toString() ==
          "0000ffe1-0000-1000-8000-00805f9b34fb") {
        Uint8List value = await device.readCharacteristic(c);

        Uint8List llv_l = new Uint8List(4);
        llv_l[0] = value[0];
        llv_l[1] = value[1];
        llv_l[2] = value[2];
        llv_l[3] = value[3];

        Uint8List temo_l = new Uint8List(4);
        temo_l[0] = value[4];
        temo_l[1] = value[5];
        temo_l[2] = value[6];
        temo_l[3] = value[7];

        Uint8List bat_l = new Uint8List(4);
        bat_l[0] = value[12];
        bat_l[1] = value[13];
        bat_l[2] = value[14];
        bat_l[3] = value[15];

        //print("------------");
        //print(llv_l.buffer.asByteData().getFloat32(0,Endian.little));
        //print(temo_l.buffer.asByteData().getFloat32(0,Endian.little));
        //print(bat_l.buffer.asByteData().getFloat32(0,Endian.little));
        //print("-------------");

        var bdata = value.buffer.asByteData();

        var cal = {
          "m": 0.126143983,
          "b": -107.3209827 - 5
        };
        var data_val = {
          'llv': llv_l.buffer.asByteData().getFloat32(0,Endian.little),
          'temperature': temo_l.buffer.asByteData().getFloat32(0,Endian.little),
          'in_temperature': 0,
          'bat': bat_l.buffer.asByteData().getFloat32(0,Endian.little),
        };

        llv = cal['m'] * data_val['llv'] + cal['b'];
        llv = llv < 0 ? 0 : llv;
        llv=llv*10;
        llv.round();
        llv=llv/ 10;
        temperature = data_val['temperature']*10;
        temperature.round();
        temperature = temperature / 10;

        bat = data_val['bat'] / 1000;

        if (data_val['bat'] <= 3.3) {
          bat = 24;
          batIndicator = 'assets/images/bat1.png';
          batColor = Colors.red;
          /*batIndicator = CircleAvatar(
            child: Image.asset('assets/images/bat1.png', color: Colors.red,),
            backgroundColor: Colors.transparent,
          ); */
        } else if (data_val['bat']  <= 3.5) {
          bat = 49;
          batColor = Colors.orange;
          batIndicator = 'assets/images/bat2.png';
          /*batIndicator = CircleAvatar(
            child: Image.asset('assets/images/bat2.png', color: Colors.deepOrange,),
            backgroundColor: Colors.transparent,
          );*/
        } else if (data_val['bat']  <= 3.8) {
          bat = 74;
          batIndicator = 'assets/images/bat3.png';
          batColor = Colors.amber;
          /*batIndicator = CircleAvatar(
            child: Image.asset('assets/images/bat3.png', color: Colors.amber,),
            backgroundColor: Colors.transparent,
          );*/
        } else {
          bat = 100;
          batIndicator = 'assets/images/bat4.png';
          //batColor = Color(0x00ce4d);
          batColor = Colors.green;
          /*batIndicator = CircleAvatar(
            child: Image.asset('assets/images/bat4.png', color: Colors.green),
            backgroundColor: Colors.transparent,
          );*/
        }

        //print(llv);
        //print(temperature);
        //print(bat);
      }
    }
    //setState(() {});
  }

  void tryConnect() async{

    if(isConnected){
      //debugPrint("Connected");
      if(!_done){
        for(BluetoothService s in services) {
          //print("SERVICE");
          //print(s.uuid.toString());
          if (s.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb") {
            for (BluetoothCharacteristic c in s.characteristics) {
              //print("CHARACT");
              //print(c.uuid.toString());
              if(c.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb"){
                //print("HEKLOOOOLSDOSD");
                await device.setNotifyValue(c, true);
                device.onValueChanged(c).listen((value) {
                  //print("Reading...");
                  if(!_doneRead){
                    _doneRead=true;
                    readC(s);
                  }
                  setState(() {_doneRead=false;});
                });
              }
            }
          }
          _done = true;
        }
      }
    } else {
      if(!_doneScan) {
        _startScan();
        _doneScan = true;
      }

      for (var val in scanResults.values) {
        //debugPrint(val.advertisementData.localName);
        //print(val.advertisementData.localName);
        //debugPrint("Searching");
        if (val.advertisementData.localName == qrResult) {
          var reversed = scanResults.map((k, v) => MapEntry(v, k));
          _connect(scanResults[reversed[val]].device);
          result = scanResults[reversed[val]].advertisementData.localName;
          //debugPrint("Connecting...");
          _stopScan();
        }
      }
    }
  }
  void _refreshAll() async{
    for(BluetoothService s in services) {
      if (s.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb") {
        readC(s);
      }
      _done = true;
    }
  }
  static const _kFontFam = 'MyFlutterApp';
  static const IconData temperatire = const IconData(0xe800, fontFamily: _kFontFam);
  static const IconData battery_4 = const IconData(0xf240, fontFamily: _kFontFam);
  static const IconData battery_3 = const IconData(0xf241, fontFamily: _kFontFam);
  static const IconData battery_2 = const IconData(0xf242, fontFamily: _kFontFam);
  static const IconData battery_1 = const IconData(0xf243, fontFamily: _kFontFam);
  static const IconData battery_0 = const IconData(0xf244, fontFamily: _kFontFam);

  List<charts.Series<double, int>> _createSampleData() {
  var data = graphTemp(d2,double.parse(temperature.toStringAsFixed(3)));
    return [
      new charts.Series<double, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (double value, _) => value.toInt(),
        measureFn: (double sales, _) => sales.toInt(),
        data: data,
      )
    ];
  }


  @override
  Widget build(BuildContext context) {

    var titles = new List();

    //double _vartest = double.parse(titles.length.toString());
    double _vartest;
    tryConnect();

    var temp = double.parse(time);
    timestamp = (new DateTime.now().millisecondsSinceEpoch);
    timestamp=timestamp+temp.toInt();



    if(isConnected) {
      d1 = graph(d1,double.parse(llv.toStringAsFixed(3)));
      d2 = graphTemp(d2,double.parse(temperature.toStringAsFixed(3)));
      timestamps = graphTime(timestamps,timestamp.toDouble());
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
                        Text(result, textAlign: TextAlign.left,style: TextStyle(fontSize: 25)),
                        deviceStatus(bat.toStringAsFixed(0)),
                        //Text("ON", textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                      ],
                    ),

                  ],
                ),
              ),

              _charTile("Temperature", double.parse(temperature.toStringAsFixed(3)), 'assets/images/temp1.png', ' ºC'),
              _charTile("Liquid Level",  double.parse(llv.toStringAsFixed(3)),'assets/images/liquid.png', ' mm'),
              _charTileTimestamp("Timestamp", timestamp, 'assets/images/timestamp.png',""),
              SizedBox(height: 20),
              Text("Liquid Level Data (mm)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),textAlign: TextAlign.center,),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 200,
                  width:  200,
                  child: /*new FutureBuilder(
                    future: graph(d1),
                    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                      print(snapshot.data);
                      d1.add(0);*/

                  /*Sparkline(
                    //data: widget.den,
                    data: graph(d1,double.parse(llv.toStringAsFixed(3))),
                    lineColor: Functions.winegridColor(),
                    fillMode: FillMode.below,
                    fillColor: Colors.grey[300],
                    pointsMode: PointsMode.all,
                    pointSize: 5.0,
                    pointColor: Colors.black,

                  ),*/
                  new charts.LineChart(_createSampleData3(),
                      animate: true,
                      //defaultRenderer: new charts.LineRendererConfig(includePoints: true),
                      //domainAxis: new charts.,
                      // Provide a tickProviderSpec which does NOT require that zero is
                      // included.
                      primaryMeasureAxis: new charts.NumericAxisSpec(
                          tickProviderSpec:
                          new charts.BasicNumericTickProviderSpec(zeroBound: false, dataIsInWholeNumbers: false))),

                  //},
                  //),
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
                  child: /*new FutureBuilder(
                    future: graph(d1),
                    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                      print(snapshot.data);
                      d1.add(0);*/
                  //new charts.LineChart(_createSampleData2(), animate: true,),
                    new charts.LineChart(_createSampleData2(),
                      animate: true,
                      //defaultRenderer: new charts.LineRendererConfig(includePoints: true),
                      //domainAxis: new charts.,
                      // Provide a tickProviderSpec which does NOT require that zero is
                      // included.
                      primaryMeasureAxis: new charts.NumericAxisSpec(
                      tickProviderSpec:
                      new charts.BasicNumericTickProviderSpec(zeroBound: false, dataIsInWholeNumbers: false))),


                 /* Sparkline(
                    //data: widget.den,
                    data: graphTemp(d2,double.parse(temperature.toStringAsFixed(3))),
                    lineColor: Functions.winegridColor(),
                    fillMode: FillMode.below,
                    fillColor: Colors.grey[300],
                    pointsMode: PointsMode.all,
                    pointSize: 5.0,
                    pointColor: Colors.black,

                  ),*/

                  //},
                  //),
                ),
              ),
              //_charTile("Battery",  double.parse(bat.toStringAsFixed(3)),'assets/images/battery.png'," %"),
              //Tab(icon: Icon(battery_0)),
            ],
          ),
        ),
      );
    }
    else{
      //if Not connected
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
                        Text(result, textAlign: TextAlign.left,style: TextStyle(fontSize: 25)),
                        deviceStatus(bat.toStringAsFixed(0)),
                        //Text("ON", textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                      ],
                    )
                  ],
                ),
              ),

              _charTile("Temperature", 0.0, 'assets/images/temp1.png', ' ºC'),
              _charTile("Liquid Level",  0.0,'assets/images/liquid.png', ' mm'),
              _charTileTimestamp("Timestamp", 0, 'assets/images/timestamp.png',""),
              //_charTile("Battery",  double.parse(bat.toStringAsFixed(3)),'assets/images/battery.png'," %"),
              //Tab(icon: Icon(battery_0)),
            ],
          ),
        ),

        /*floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.refresh),
          backgroundColor: _winegridColor(),
          label: Text("Refresh"),
          onPressed: _refreshAll,
        ), */



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
            Text(DateTime.fromMillisecondsSinceEpoch(timestamp).toString(),
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

  Widget deviceStatus(bat1) {
    if(deviceState == BluetoothDeviceState.connected) {
      return new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            child: Image.asset('assets/images/on.png'),
              backgroundColor: Colors.transparent,
          ),
          SizedBox(width: 10),
          CircleAvatar(
            child: Image.asset(batIndicator, color: batColor),
            backgroundColor: Colors.transparent,
          ),
          //batIndicator
        ],
      );  //Text("ON", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, background: Paint()..color = Color(0x00ce4c)),);
    } else {
      //timestamp = 0;
      llv = 0.0;
      temperature = 0.0;
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CircleAvatar(
            child: Image.asset('assets/images/off.png'),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(width: 10),
          CircleAvatar(
            child: Image.asset('assets/images/bat0.png', color: Colors.grey),
            backgroundColor: Colors.transparent,
          ),
          //batIndicator
        ],
      );
    }
  }

  Color _winegridColor() {
    return new Color(0xffa32942);
  }

  /// Create one series with sample hard coded data.
    static List<charts.Series<LinearData, double>> _createSampleData2() {
     var temp = graphTemp(d2,double.parse(temperature.toStringAsFixed(3)));
     var timestp = graphTime(timestamps,timestamp.toDouble());
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
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
       domainFn: (LinearData sales, _) => sales.index,
        measureFn: (LinearData sales, _) => sales.temp,
        //measureLowerBoundFn: (LinearData sales, _) => (sales.temp - 0.5),
        //measureUpperBoundFn: (LinearData sales, _) => (sales.temp + 0.5),
        data: data,
      )
    ];
  }

   static List<charts.Series<LinearLiquid, double>> _createSampleData3() {
     var res = graph(d1,double.parse(llv.toStringAsFixed(3)));
     //var timestp = graphTime(timestamps,timestamp.toDouble());
     final data = [
       new LinearLiquid(0, res[0]),
       new LinearLiquid(1, res[1]),
       new LinearLiquid(2, res[2]),
       new LinearLiquid(3, res[3]),
       new LinearLiquid(4, res[4]),
       new LinearLiquid(5, res[5]),
       new LinearLiquid(6, res[6]),
       new LinearLiquid(7, res[7]),
       new LinearLiquid(8, res[8]),
       new LinearLiquid(9, res[9]),
     ];

     return [
       new charts.Series<LinearLiquid, double>(
         id: 'Liquid Level',
         colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
         domainFn: (LinearLiquid sales, _) => sales.index,
         measureFn: (LinearLiquid sales, _) => sales.press,
         data: data,

       )
     ];
   }
}


class LinearData {
  final double index;
  final double temp;

  LinearData(this.index, this.temp);
}

class LinearLiquid {
  final double index;
  final double press;

  LinearLiquid(this.index, this.press);
}