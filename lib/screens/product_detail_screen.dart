import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title),),
    );
  }
}
