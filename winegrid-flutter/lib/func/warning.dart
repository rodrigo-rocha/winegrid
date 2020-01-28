import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FunctionDialogue {

  /// ALERT DIALOGUES
  static void confirmationWarning(BuildContext context, pressedAction()) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "LEAVE PAGE?",
      desc: "Are you sure you want to discard the note and leave?",
      buttons: [
        DialogButton(
          child: Text(
            "Leave",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            pressedAction();
          },
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            "Don't Leave",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.green,
        ),
      ],
    ).show();
  }

}