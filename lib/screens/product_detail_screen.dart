import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/screens/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    // detay için sadece bir ürünü bi kere görüyoruz, provider sınıfta herhangi
    // bir değişiklik olursa detay sayfasında bunun her defasında rebuild
    // olmasına ihtiyaç yok bu yüzden listen parametresi false atandı
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false).findById(
        productId);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final themeOf = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    loadedProduct.imageUrl, fit: BoxFit.cover,),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${loadedProduct.description}', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: themeOf.accentColor,
                    child: Center(
                      heightFactor: 2,
                      widthFactor: 1.5,
                      child: Text('\$${loadedProduct.price}',
                        style: TextStyle(color: Colors.white, fontSize: 22),),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: RaisedButton.icon(
                      textTheme: ButtonTextTheme.primary,
                      icon: Icon(Icons.add_shopping_cart, size: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: themeOf.primaryColor,
                      splashColor: themeOf.accentColor,
                      elevation: 4,
                      label: const Text(
                        'Add to Cart', style: TextStyle(fontSize: 20),),
                      onPressed: () {
                        cart.addItemToCart(
                            loadedProduct.id, loadedProduct.title,
                            loadedProduct.price);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
