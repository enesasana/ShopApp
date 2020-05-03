import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Buraya Notifier eklemek buranın her değişiklikte baştan oluşturulacağı
    // anlamına gelmiyor, sadece listener'ların dinledikleri widgetlar rebuild
    // edilir.
    return ChangeNotifierProvider(
      // ChangeNotifierProvider.value( value: ..) şeklinde de kullanılabilir
      // value: ProductProvider(),
      //
      // Ama burada bir sınıftan yeni bir object instantiate ettiğim için crete
      // builder'ını kullanmak efficiency'i arttırıp bug'ların önüne geçer
      //
      //create: (_) => ... eğer kullandığım provider contexten bağımsız olursa
      // böyle de kullanılabilir
      create: (ctx) => ProductProvider(),
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
        title: Text('My Shop'),
      ),
      body: Center(
        child: Text('center text'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
