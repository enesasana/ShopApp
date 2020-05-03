import 'package:flutter/material.dart';
import 'package:shopapp/widgets/products_grid.dart';

enum PopupOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert,),
            onSelected: (PopupOptions selectedValue) {
              setState(() {
                if (selectedValue == PopupOptions.Favorites) {
                  _showOnlyFavorites = true;
                }
                else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) =>
            [
              PopupMenuItem(
                child: Text('Only Favorites'), value: PopupOptions.Favorites,),
              PopupMenuItem(
                child: Text('Show All'), value: PopupOptions.All,),
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
