import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:winegrid/auth/auth_functions.dart';

class APIFunctions {

  static String jwtS = "";

  // Login cred
  static Future<http.Response> callWebServiceForLoginUser(String userN, String pwd, successActions(), failActions()) async {

    print("login called");

    final paramDic = {
      "username": userN,
      "password": pwd,
    };

    final loginData = await http.post(
      "https://wine.watgrid.com/api/auth/login/",  // change with your API
      body: paramDic,
    );

    var jsonData = json.decode(loginData.body);

    print(loginData.statusCode);

    if(loginData.statusCode != 200) {
      failActions();
    } else {
      var jS = jsonData['token'];
      var newJWT = jS.toString().split(':');
      jwtS = "JWT " + newJWT[1].substring(1, (newJWT[1].length)-1);
      successActions();
    }

    return loginData;
  }

  static Future<http.Response> callWebServiceForLogout() async {

    final paramDicIn = {
      "authorization": jwtS
    };

    final loginData = await http.post(
      "https://wine.watgrid.com/api/auth/logout/",  // change with your API
      headers: paramDicIn,
    );

    APIFunctions.jwtS = "";

    print(loginData.body);
    print(loginData.statusCode);

    return loginData;
  }

  static Future<http.Response> callWebServiceForDeletingNotes(String noteID) async {

    final paramDicIn = {
      "authorization": APIFunctions.jwtS
    };

    final loginData = await http.delete(
      "https://wine.watgrid.com/api/dashboard/notes/$noteID/",  // change with your API
      headers: paramDicIn,
    );

    return loginData;
  }

  static Future<http.Response> callWebServiceReadingNotes() async {

    final paramDicIn = {
      "authorization": APIFunctions.jwtS
    };

    //print(jwt_string);

    final loginData = await http.get(
      "https://wine.watgrid.com/api/dashboard/notes/all/",  // change with your API
      headers: paramDicIn,
    );

    return loginData;
  }

  static Future<http.Response> callWebServiceReadingProcesses() async {

    final paramDicIn = {
      "authorization": APIFunctions.jwtS
    };

    //print(jwt_string);

    final loginData = await http.get(
      "https://wine.watgrid.com/api/dashboard/processes/",  // change with your API
      headers: paramDicIn,
    );

    return loginData;
  }

  static Future<http.Response> callWebServiceReadingImages(String image) async {

    final paramDicIn = {
      "authorization": APIFunctions.jwtS,
      "cookie" : "csrftoken=qkACgIdcvtW1zTR4oqDY4HmpBpVC2A11; _ga=GA1.2.1940932058.1554904371; sessionid=6iaie44n8f78pbz7zefvznij8ssmaqs2; _gid=GA1.2.808280307.1555016646"
    };

    //print(jwt_string);

    final loginData = await http.get(
      "https://wine.watgrid.com/api/dashboard/notes/files/$image",  // change with your API
      headers: paramDicIn,
    );

    //print("https://wine.watgrid.com/api/dashboard/notes/files/$image");
    if(loginData.statusCode == 200) {
      print("Success");
    } else {
      print("FAIL");
    }

    return loginData;
  }

  static Future<http.Response> callWebServiceForEditingNotes(String noteID, String title, String content) async {

    final paramDicIn = {
      "authorization": APIFunctions.jwtS
    };

    final paramDicOut = {
      "title": title,
      "body": content
    };

    final loginData = await http.patch(
      "https://wine.watgrid.com/api/dashboard/notes/$noteID/",  // change with your API
      headers: paramDicIn,
      body: paramDicOut,
    );

    print(loginData.body);
    print(loginData.statusCode);

    return loginData;
  }

  static Future<http.Response> callWebServiceForCreateNote(String title, String description) async {

    final paramDicIn = {
      "authorization": APIFunctions.jwtS
    };

    final paramDicOut = {
      "title": title,
      "body": description
    };

    final loginData = await http.post(
      "https://wine.watgrid.com/api/dashboard/notes/",  // change with your API
      headers: paramDicIn,
      body: paramDicOut,
    );

    //print(loginData.body);
    print(loginData.statusCode);

    return loginData;
  }

  static Future<http.Response> callWebServiceForStoppingProcess(String procID, String datetime, successActions(), failActions()) async {

    final paramDicIn = {
      "authorization": APIFunctions.jwtS
    };

    final paramDicOut = {
      "ended_at": datetime,
      "finished": 'true'
    };

    final loginData = await http.patch(
      "https://wine.watgrid.com/api/dashboard/processes/$procID/",  // change with your API
      headers: paramDicIn,
      body: paramDicOut,
    );

    if(loginData.statusCode != 200) {
      failActions();
    } else {
      successActions();
    }

    print(loginData.body);
    print(loginData.statusCode);

    return loginData;

  }
}