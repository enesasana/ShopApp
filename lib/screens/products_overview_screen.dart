import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
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
  var _isInit = true;
  var _isLoading = false;

  // In order to fetch the data from firebase
  @override
  void initState() {
    // WON'T WORK - 'of' logic does not work in initState like ModalRoute.of
    // Provider.of<ProductProvider>(context,).fetchAndSetProducts();
    // Provider.of<ProductProvider>(context, listen: false).fetchAndSetProducts(); -> this can be work

    // Instead you could use this -kinda hack
    /*Future.delayed(Duration.zero).then((_){
      Provider.of<ProductProvider>(context,).fetchAndSetProducts();
    }); */

    // But also didChange Dependencies() approach is much better
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Sadece bir kere çalıştırmak için
    if (_isInit) {
      // Without then it works. I added then method in order to tell the users
      // something going on for the moment
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context,).fetchAndSetProducts().then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          Consumer<CartProvider>(
            // burda parametre olan ch aslında builder fonksiyonunun dışında
            // tanımlanan IconButton child'ı
              builder: (_, cart, ch) =>
                  Badge(
                    child: ch,
                    value: cart.itemCountInCart.toString(),
                  ),
              child: IconButton(
                icon: Icon(Icons.shopping_basket),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              )
          ),
          PopupMenuButton(
            offset: Offset(0, 50),
            padding: EdgeInsets.all(8),
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
                child: const Text('Show Favorites'),
                value: PopupOptions.Favorites,),
              PopupMenuItem(
                child: const Text('All Products'), value: PopupOptions.All,),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
