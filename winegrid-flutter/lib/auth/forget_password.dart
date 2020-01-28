import 'package:flutter/material.dart';
import 'package:winegrid/auth/auth_functions.dart';
import 'package:winegrid/func/functions.dart';

TextEditingController emailController = new TextEditingController();
final FocusNode _emailFocus = FocusNode();

class ForgotPassword extends StatefulWidget {

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).detach();
        },
        child:
        ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Functions.showLogo(),
            Text("PASSWORD RESET", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 15),
            info(),
            forgetPasswordForm(),
            SizedBox(height: 15),
            sendButton(),
            SizedBox(height: 15),
            AuthFunctions.goBack(context),
          ],
        ),
      ),
    );
  }

  Widget info() {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: Text(
        "Fill with your mail to receive instructions on how to reset your password.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget forgetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          AuthFunctions.credWidget("E-Mail", false, Icons.mail_outline, emailController, _emailFocus, _emailFocus, context),
        ],
      ),
    );
  }

  Widget sendButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.of(context).pushNamed('/login');
          }
        },
        padding: EdgeInsets.all(12),
        color: Functions.winegridColor(),
        child: Text("SEND E-MAIL",
          style: TextStyle(
              fontSize: 15,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}