import 'dart:async';
import 'package:winegrid/func/functions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

bool _done = false;
final String result = "";

class QR_Result {
  static String res_name = result;
}

class QRScan extends StatefulWidget {
  @override
  QRScanState createState() {
    return new QRScanState();
  }
}

class QRScanState extends State<QRScan> {
  static String result = "No results yet. Please scan in the button bellow.";

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

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    super.dispose();
  }

  _buildAlertTile() {
    return new Container(
      color: Functions.winegridColor(),
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: TextStyle(color: Colors.white),
        ),
        trailing: new Icon(
          Icons.error,
          color: Colors.white,
        ),
      ),
    );
  }

  Future _scanQR() async { // Wait until it's done
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        if(qrResult.startsWith("http"))
        {
          var lista = new List(5);
          lista = qrResult.split('/');
          result = lista[4];
          print(result);
        }
        else {
          result = qrResult;
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied.";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex.";
        });
      }
    } on FormatException {
      setState(() {
        result = "Scanning unsuccessful. Please try again.";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if(!_done) {
      _scanQR();
      _done = true;
    }

    print('${state.toString().substring(15)}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Functions.wineBar("QR Code Scanner"),
      body: Center(
        child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.center, // Center Button
            //mainAxisSize: MainAxisSize.min, // Center Button
            children: <Widget>[
              _buildAlertTile(),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: CircleAvatar(
                  //backgroundImage: AssetImage(),
                  child: Image.asset('assets/images/sensor_ble.png'),
                  backgroundColor: Colors.transparent,
                  radius: 100,
                ),
              ),
              Card(
                shape: UnderlineInputBorder(borderSide: BorderSide(width: 0.3)),
                elevation: 0.0,
                child: ListTile(

                  title: Text(result),
                  subtitle: Text("DEVICE SCANNED"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("CONNECT", style: TextStyle(color: Colors.white, fontSize: 16)),
                    color: Functions.winegridColor(),
                    onPressed: () {
                      if(state.toString().substring(15) == 'off') {
                        showBluetoothAdapterInfo();
                      } else if(result == "Scanning unsuccessful. Please try again.") {
                        showNoDeviceConnected();
                      } else {
                        Navigator.of(context).pushNamed('/connectedDevice');
                      }
                    },
                  ),

                  RaisedButton(
                    child: Text("NEW SCAN", style: TextStyle(color: Colors.white, fontSize: 16)),
                    color: Functions.winegridColor(),
                    onPressed: () {
                      if(state.toString().substring(15) == 'off') {
                        showBluetoothAdapterInfo();
                      } else {
                        _scanQR();
                      }

                    },
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }

  void showBluetoothAdapterInfo() {
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

  void showNoDeviceConnected() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Center(
          child: AlertDialog(
            title: new Text("No device is currently paired", style: TextStyle(color: Functions.winegridColor()),),
            content: Text("Please scan for a valid device."),
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