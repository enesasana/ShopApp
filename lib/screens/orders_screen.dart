import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/order_provider.dart' show OrderProvider;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';
import 'package:shopapp/buttons/continue_shopping.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ordersData.orders.length == 0
          ? ContinueShopping('You have no order')
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (ctx, index) => OrderItem(ordersData.orders[index]),
            ),
    );
  }
}
