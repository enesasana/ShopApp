import 'package:flutter/material.dart';

class CheckOrders extends StatelessWidget {
  final String route;

  CheckOrders(this.route);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      textTheme: ButtonTextTheme.primary,
      icon: Icon(Icons.payment, size: 30,),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      color: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).accentColor,
      elevation: 5,
      label: const Text(
        'Check Orders', style: TextStyle(fontSize: 24),),
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },);
  }
}
