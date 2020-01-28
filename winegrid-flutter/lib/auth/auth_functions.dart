import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AuthFunctions {

  static Widget createAccount(BuildContext ctx) {
    return Container(
      //padding: EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.of(ctx).pushNamed('/signup');
        },
        child: Text('Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  static Widget goBack(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      height: 40.0,
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1.0
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: InkWell(
            onTap: (){
              Navigator.of(ctx).pushReplacementNamed('/login');
            },
            child: Center(
              child: Text('Go Back',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'
                ),
              ),
            )
        ),
      ),
    );
  }

  static Widget credWidget(String text, bool pw, IconData icon, TextEditingController cont, FocusNode current, FocusNode next, BuildContext ctx) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: TextFormField(
        cursorColor: Colors.black,
        controller: cont,
        focusNode: current,
        validator: (val) => val.isEmpty? 'This field can\'t be empty' : null,
        onFieldSubmitted: (term) {
          current.unfocus();
          if(current != next) {
            FocusScope.of(ctx).requestFocus(next);
          }
        },
        //textInputAction: TextInputAction.go,
        obscureText: pw,
        decoration: InputDecoration(
          suffixIcon: Icon(icon),
          labelText: text,
          //border: UnderlineInputBorder(
            //borderRadius: BorderRadius.circular(10.0),
            //borderSide: BorderSide(color: Functions.winegridColor()),
          //)
        ),
      ),
    );
  }

  static void displayError(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "INVALID USERNAME OR PASSWORD",
      desc: "Please enter a valid e-mail and password",
      buttons: [
        DialogButton(
          child: Text(
            "CLOSE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color:  new Color(0xffa32942),
        ),
      ],
    ).show();
  }

}