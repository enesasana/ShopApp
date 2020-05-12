import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/order_provider.dart' show OrderProvider;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';
import 'package:shopapp/buttons/continue_shopping.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  var _isLoading = false;

  @override
  void initState() {
    // Bu şekilde yapınca bütün yüklemelerin sonunda burası execute edilecek
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<OrderProvider>(context, listen: false)
          .fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator())
          : (ordersData.orders.length == 0 || ordersData.orders == null)
          ? ContinueShopping('You have no order')
          :
      ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, index) => OrderItem(ordersData.orders[index]),
      ),
    );
  }
}
