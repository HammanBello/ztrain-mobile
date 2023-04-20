import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';

class AppProductManager extends ChangeNotifier {
  Product _selectedProduct;
  int _selectedProductQuantity;

  Product get selectedProduct => _selectedProduct;
  int get selectedProductQuantity => _selectedProductQuantity;

  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void setSelectedProductQuantity(int quantity) {
    _selectedProductQuantity = quantity;
    notifyListeners();
  }
}
