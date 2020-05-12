import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'An error occured',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.red),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Something went wrong',
          textAlign: TextAlign.center,
        ),
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.all(8.0),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
