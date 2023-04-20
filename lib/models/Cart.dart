import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart {
  String id;
  final String productId;
  final String userId;
  final int quantity;
  final double price;

  Cart({
    this.id,
    @required this.userId,
    @required this.productId,
    @required this.quantity,
    @required this.price,
  });

  factory Cart.fromMap(Map data) {
    return Cart(
        userId: data['userId'],
        productId: data['productId'],
        quantity: data['quantity'],
        price: data['price']);
  }

  factory Cart.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Cart(
        id: doc.id,
        userId: data['userId'],
        productId: data['productId'],
        quantity: data['quantity'],
        price: data['price']);
  }
}
