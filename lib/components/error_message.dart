import 'package:flutter/material.dart';

class ErrorDialog {
  errorMessage({@required BuildContext context, @required e}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error Message'),
            content: Text(e),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
