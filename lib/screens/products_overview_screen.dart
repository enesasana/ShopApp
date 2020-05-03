import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/badge.dart';
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
                child: Text('Show Favorites'), value: PopupOptions.Favorites,),
              PopupMenuItem(
                child: Text('All Products'), value: PopupOptions.All,),
            ],
          ),
          Consumer<CartProvider>(
            // burda parametre olan ch aslında builder fonksiyonunun dışında
            // tanımlanan IconButton child'ı
              builder: (_, cart, ch) =>
                  Badge(
                    child: ch,
                    value: cart.itemCountInCart.toString(),
                  ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              )
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
