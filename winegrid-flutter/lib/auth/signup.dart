import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/auth/auth_functions.dart';

TextEditingController usernameController = new TextEditingController();
TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController verifyController = new TextEditingController();
TextEditingController tokenController = new TextEditingController();

FocusNode userFocus = new FocusNode();
FocusNode emailFocus = new FocusNode();
FocusNode passwordFocus = new FocusNode();
FocusNode newPassFocus = new FocusNode();
FocusNode tokenFocus = new FocusNode();

class SignupPage extends StatefulWidget{
  @override
  SignupPageState createState()=> SignupPageState();
}

class SignupPageState extends State<SignupPage>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).detach(),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            SizedBox(height: 20),
            Functions.showLogo(),
            Text('SIGNUP TO GET ACCESS', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 15),
            signupForm(),
            SizedBox(height: 20),
            signupButton(),
            SizedBox(height: 15),
            AuthFunctions.goBack(context),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget signupButton() {

    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()) {
            print("No implementation ");
            Navigator.of(context).pushReplacementNamed('login');
          }
        },
        padding: EdgeInsets.all(12),
        color: Functions.winegridColor(),
        child: Text("CREATE ACCOUNT",
          style: TextStyle(
              fontSize: 15,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget signupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          AuthFunctions.credWidget("Username", false, Icons.account_circle, usernameController, userFocus, emailFocus, context),
          SizedBox(height: 15),
          AuthFunctions.credWidget("E-Mail", false, Icons.mail_outline, usernameController, emailFocus, passwordFocus, context),
          SizedBox(height: 15),
          AuthFunctions.credWidget("Password", false, Icons.lock_outline, usernameController, passwordFocus, newPassFocus, context),
          SizedBox(height: 15),
          AuthFunctions.credWidget("Repeat Password", false, Icons.lock, usernameController, newPassFocus, tokenFocus, context),
          SizedBox(height: 15),
          AuthFunctions.credWidget("Ativation Token", false, Icons.vpn_key, usernameController, tokenFocus, tokenFocus, context),
        ],
      ),
    );
  }
}