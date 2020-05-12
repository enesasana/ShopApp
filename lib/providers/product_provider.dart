import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http; // Prefix

class ProductProvider with ChangeNotifier {

  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];


  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }


  Future<void> addProduct(Product product) {
    const url = 'https://shop-app-467f5.firebaseio.com/products.json';
    return http.post(url, body: json.encode({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    }),).then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);  // at the start of the list
      notifyListeners();
    });

    // Bu sınıfı dinleyen sınıf veya widgetlar için bu sınıfta veriler üzerinde
    // herhangi bir değişiklik gerçekleşirse aşağıdaki metod ile bu verileri
    // kullanan veya bir şekilde ilişkisi olan widgetlar bu değişiklikten
    // haberdar olabilecekler
    //
    // Çünkü veri üzerindeki değişiklikleri tek bir noktadan yapıp ordan
    // distribute etmek hem passing data hem de bunu distribute ederken kolaylık
    // sağlar.
    // notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if(productIndex >= 0){
      _items[productIndex] = newProduct;
    }
    else {
      print('...');
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

}