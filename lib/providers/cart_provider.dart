import 'package:cbs/providers/product_class.dart';
import 'package:cbs/providers/sql.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier {
  static List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(Product product) async {
    await SQLHelper.insertCartItem(product)
        .whenComplete(() => _list.add(product));

    notifyListeners();
  }

  loadCartItemsProvider() async {
    List<Map> data = await SQLHelper.loadItems();
    _list = data.map((product) {
      return Product(
        documentId: product['documentId'],
        name: product['name'],
        price: product['price'] as double,
        qty: product['qty'],
        qntty: product['qntty'],
        imagesUrl: product['imagesUrl'],
        suppId: product['suppId'],
      );
    }).toList();
    notifyListeners();
  }

  void increment(Product product) async {
    await SQLHelper.updateCartItem(product, 'increment')
        .whenComplete(() => product.increase());

    notifyListeners();
  }

  void reducebyOne(Product product) async {
    await SQLHelper.updateCartItem(product, 'reduce')
        .whenComplete(() => product.decrease());

    notifyListeners();
  }

  void removeItem(Product product) async {
    await SQLHelper.deleteCartItem(product.documentId)
        .whenComplete(() => _list.remove(product));

    notifyListeners();
  }

  void clearCart() async {
    await SQLHelper.deleteAllItems().whenComplete(() => _list.clear());
    _list.clear();
    notifyListeners();
  }
}
