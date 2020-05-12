import 'package:flutter/material.dart';

class ContinueShopping extends StatelessWidget {
  final String description;

  ContinueShopping(this.description);

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            description,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            child: RaisedButton.icon(
              textTheme: ButtonTextTheme.primary,
              icon: Icon(Icons.add_shopping_cart),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: themeOf.primaryColor,
              splashColor: themeOf.accentColor,
              elevation: 5,
              label: const Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ),
        ],
      ),
    );
  }
}
