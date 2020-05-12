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
    final orderCount = orderData.orders.length; // 0 -> Empty
    final themeOf = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body:
      Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 24),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        child: Chip(
                          elevation: 5,
                          label: Text(
                            '\t\$${cartData.totalAmountOfCart.toStringAsFixed(
                                2)}\t',
                            style: TextStyle(
                                color: themeOf.primaryTextTheme.title.color,
                                fontSize: 20
                            ),
                          ),
                          backgroundColor: themeOf.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerRight,
                          child: OrderNowButton(cartData: cartData,)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // List of added Products
          cartData.totalAmountOfCart == 0
              ? orderCount == 0
              ? Card(margin:EdgeInsets.all(15),child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ContinueShopping('Your cart is empty :('),
              ))
              : ShowButtons()
              : Expanded(
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

class OrderNowButton extends StatefulWidget {
  final CartProvider cartData;

  const OrderNowButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    return _isLoading
        ? CircularProgressIndicator(strokeWidth: 2.0,)
        :
    OutlineButton.icon(
      splashColor: themeOf.primaryColor,
      label: const Text(
        'Order Now',
        style: TextStyle(fontSize: 18),
      ),
      icon: Icon(Icons.arrow_forward_ios),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      onPressed: (widget.cartData.totalAmountOfCart == 0 || _isLoading == true)
          ? null
          : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<OrderProvider>(context, listen: false).addOrder(
            widget.cartData.items.values.toList(),
            widget.cartData.totalAmountOfCart);
        setState(() {
          _isLoading = false;
        });
        widget.cartData.clearCartAfterOrder();
      },
    );
  }
}

class ShowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Your cart is empty but you have order',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),),
              ),
              CheckOrders(OrdersScreen.routeName),
              ContinueShopping('')
            ],
          ),),
      ),
    );
  }
}
