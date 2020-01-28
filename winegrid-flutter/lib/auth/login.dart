import 'package:flutter/material.dart';
import 'package:winegrid/func/functions.dart';
import 'package:winegrid/auth/auth_functions.dart';
import 'package:winegrid/api/api_functions.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

final FocusNode _emailFocus = FocusNode();
final FocusNode _passFocus = FocusNode();

class Login extends StatefulWidget {

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).detach();
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            SizedBox(height: 20),
            Functions.showLogo(),
            SizedBox(height: 40),
            loginForm(),
            SizedBox(height: 15),
            forgotPassword(),
            SizedBox(height: 15),
            loginButton("LOGIN", '/main_menu'),
            SizedBox(height: 15),
            AuthFunctions.createAccount(context)
          ],
        ),
      ),
    );
  }

  Widget forgotPassword() {
    return Container(
      padding: EdgeInsets.only(right: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/forgot_password');
        },
        child: Text('Forgot Password',
            textAlign: TextAlign.end,
            style: TextStyle(
                fontWeight: FontWeight.bold
            )
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          AuthFunctions.credWidget("Username", false, Icons.account_circle, emailController, _emailFocus, _passFocus, context),
          SizedBox(height: 15),
          AuthFunctions.credWidget("Password", true, Icons.lock_outline, passwordController, _passFocus, _passFocus, context),
        ],
      )
    );
  }

  Widget loginButton(String text, String path) {

    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {

          if(_formKey.currentState.validate()) {
            APIFunctions.callWebServiceForLoginUser(emailController.text, passwordController.text, () => successAction(), () => failAction());
          }
        },
        padding: EdgeInsets.all(12),
        color: Functions.winegridColor(),
        child: Text(text,
          style: TextStyle(
              fontSize: 15,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  void successAction() {
    Navigator.of(context).pushNamed('/main_menu');
  }

  void failAction() {
   AuthFunctions.displayError(context);
  }
}