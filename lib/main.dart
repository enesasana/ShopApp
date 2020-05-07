import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/providers/order_provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Buraya Notifier eklemek buranın her değişiklikte baştan oluşturulacağı
    // anlamına gelmiyor, sadece listener'ların dinledikleri widgetlar rebuild
    // edilir.
    return MultiProvider(
      // ChangeNotifierProvider.value( value: ..) şeklinde de kullanılabilir
      // value: ProductProvider(),
      //
      // Ama burada bir sınıftan yeni bir object instantiate ettiğim için crete
      // builder'ını kullanmak efficiency'i arttırıp bug'ların önüne geçer
      //
      //create: (_) => ... eğer kullandığım provider contexten bağımsız olursa
      // böyle de kullanılabilir
      // create: (ctx) => ProductProvider(),

      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
      ),
      body: Center(
        child: const Text('center text'),
      ),
    );
  }
}
