import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart' show CartProvider;
import 'package:shopapp/providers/order_provider.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/widgets/cart_item.dart';
import 'package:shopapp/buttons/check_orders.dart';
import 'package:shopapp/buttons/continue_shopping.dart';

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
    final orderData = Provider.of<OrderProvider>(context, listen: false);
    final itemsInCart = cartData.itemCountInCart; // 0 -> Empty
    final orderCount = orderData.orders.length; // 0 -> Empty
    final themeOf = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: itemsInCart == 0
          ? orderCount == 0
          ? ContinueShopping('Your cart is empty :(')
          : // There is not any product in the cart for the moment, but there exist order/
      Center(
        child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Your cart is empty but you have order',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 24),),
              ),
              SizedBox(height: 20,),
              Container(
                child: Column(
                  children: <Widget>[
                    CheckOrders(OrdersScreen.routeName),
                    ContinueShopping('')
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          : // If there exist a product in the Cart
      Column(
        children: <Widget>[
          // Total Amount
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
                      '\$${cartData.totalAmountOfCart.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: themeOf.primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: themeOf.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          // Order Now Button
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: OutlineButton.icon(
              splashColor: themeOf.primaryColor,
              padding: EdgeInsets.all(8),
              label: const Text(
                'Order Now',
                style: TextStyle(fontSize: 18),
              ),
              icon: Icon(Icons.arrow_forward_ios),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                orderData.addOrder(
                    cartData.items.values.toList(), cartData.totalAmountOfCart);
                cartData.clearCartAfterOrder();
              },
            ),
          ),
          SizedBox(height: 10),
          // List of added Products
          Expanded(
            child: ListView.builder(
              // cartData.items.length -> sepete eklediğimiz farklı ürün sayısı
                itemCount: cartData.items.length,
                itemBuilder: (ctx, index) => CartItem(
                  cartData.items.values.toList()[index].id,
                  cartData.items.keys.toList()[index],
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
