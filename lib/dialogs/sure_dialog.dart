import 'package:flutter/material.dart';

class SureDialog extends StatelessWidget {

  final Function execute;

  SureDialog(this.execute);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Are you sure ?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.red),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Do you want to remove this item from the list?'),
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.all(8.0),
      actions: <Widget>[
        OutlineButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            execute();
            Navigator.of(context).pop(true);
          },
        )
      ],
    );
  }
}
