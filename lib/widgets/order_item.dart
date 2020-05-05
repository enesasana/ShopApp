import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/dialogs/sure_dialog.dart';

// iki aynı OrderItem isimli widget olduğu için hangisini kullanacağımızı
// söylememiz lazım
import 'package:shopapp/providers/order_provider.dart' as ord;
import 'package:shopapp/providers/order_provider.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    final themeOf = Theme.of(context);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${widget.order.amount}', style: TextStyle(fontSize: 20),),
            subtitle: Text(
                DateFormat('dd/MM/yyyy   hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              splashColor: themeOf.accentColor,
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              //height: min(widget.order.products.length * 20.0 + 50.0, 180),
              child: Column(
                  children: <Widget>[ ListView(
                    shrinkWrap: true,
                    children: widget.order.products
                        .map(
                          (product) =>
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  product.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${product.quantity}x  \$${product.price}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                    )
                        .toList(),
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton.icon(
                            icon: Icon(Icons.delete_sweep,),
                            label: Text('Cancel Order'),
                            elevation: 5,
                            color: themeOf.accentColor,
                            onPressed: () {
                              showDialog(context: context, builder: (ctx) =>
                                  SureDialog(() {
                                    orderData.cancelOrder(widget.order.id);}
                                  ));
                            },
                          ),
                        ),
                      ],
                    )
                  ]
              ),
            ),
        ],
      ),
    );
  }
}
