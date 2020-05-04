import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart' show CartProvider;
import 'package:shopapp/widgets/cart_item.dart';

// Hem CartProvider hem de CartItem sınıflarında CartItem isimli iki object
// oluşturduğumuz ve ikisini de bu sınıfta kullandığımız için Flutter'a hangi
// noktada hangi object'i kullanması gerektiğini söylemek adına
// cart_provider.dart sınıfının yanına 'show' keywordu ekledik. Bu sayede
// Flutter'ın, ListView.builder'daki CartItem(...) widget'ının cart_item.dart
// sınıfından geldiğini anlamasını sağladık.
//
// Bunun yerine cart_item.dart sınıfının yanına cart_item.dart as CI şeklinde
// ekleme yaparak CartItem(...) widget'inin sanki local bir widget'miş gibi
// davranmasını isteyip ListView.builder'da CI.CartItem(...) şeklinde de
// kullanabilirdik.

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    final itemsInCart = cartData.itemCountInCart; // 0 -> Empty
    final themeOf = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: itemsInCart == 0
          ?
      Center(
        child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Your cart is empty :( ', style: TextStyle(fontSize: 24),),
              SizedBox(height: 20,),
              Container(
                height: 60,
                child: RaisedButton.icon(
                  textTheme: ButtonTextTheme.primary,
                  icon: Icon(Icons.add_shopping_cart),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: themeOf.primaryColor,
                  splashColor: themeOf.accentColor,
                  elevation: 4,
                  label: const Text(
                    'Go back and buy some!', style: TextStyle(fontSize: 20),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },),
              ),
            ],
          ),
        ),
      )
          :
      Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(), // Etrafındaki widget'ları gidebildikleri kadar iter
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmountOfCart}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: OutlineButton.icon(
              splashColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(8),
              label: const Text(
                'Order Now',
                style: TextStyle(fontSize: 18),
              ),
              icon: Icon(Icons.arrow_forward_ios),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              // cartData.items.length -> sepete eklediğimiz farklı ürün sayısı
                itemCount: cartData.items.length,
                itemBuilder: (ctx, index) => CartItem(
                  cartData.items.values.toList()[index].id,
                  cartData.items.values.toList()[index].title,
                  cartData.items.values.toList()[index].quantity,
                  cartData.items.values.toList()[index].price,
                )),
          ),
        ],
      ),
    );
  }
}
