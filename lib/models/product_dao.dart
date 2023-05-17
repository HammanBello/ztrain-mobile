import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/abstract_product_dao.dart';

import '../firestoreService/userService.dart';

var f = new DateFormat('ddMMyyyy');
var date = DateTime.now();

class ProductDAO extends AbsProductDAO {
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('productList');
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('Carts');
  final CollectionReference favoritesCollection =
      FirebaseFirestore.instance.collection('Favorites');
  final CollectionReference commandesCollection =
      FirebaseFirestore.instance.collection('commandes');
  final CollectionReference compteurCollection =
      FirebaseFirestore.instance.collection('compteur');
  final FirebaseAuth auth = FirebaseAuth.instance;
  double amount = 0.0;
  var incre;

  @override
  Future<List<Product>> getAllProduct() async {
    List<Product> productList = [];
    try {
      await productCollection.get().then((QuerySnapshot querySnapshot) => {
            if (querySnapshot != null)
              {
                querySnapshot.docs?.forEach((doc) {
                  Product product = Product(
                    id: doc.id,
                    images: doc['images'],
                    title: doc['title'],
                    price: doc['price'],
                    description: doc['description'],
                    isFavourite: doc['isFavorite'],
                    isPopular: true,
                  );
                  productList.add(product);
                })
              }
          });
      // print(productList);
    } catch (e) {
      print(e);
    }
    return productList;
  }

  @override
  Future<List<Cart>> getProductForCart() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    List<Cart> carts = [];
    try {
      await cartCollection
          .where('userId', isEqualTo: uid)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  Cart cart = Cart(
                      id: doc.id,
                      userId: doc['userId'],
                      productId: doc['productId'],
                      quantity: doc['quantity'],
                      price: doc['price']);
                  carts.add(cart);
                })
              });
    } catch (e) {}
    return carts;
  }

  @override
  Future<Product> getProductById(String documentId) async {
    Product testProduct;
    try {
      await productCollection.doc(documentId).get().then((value) => {
            testProduct = Product(
                id: value.id,
                images: value['images'],
                title: value['title'],
                price: value['price'],
                description: value['description'])
          });
    } catch (e) {
      print(e);
    }
    return testProduct;
  }

  @override
  Future<Product> setProductFavorite() {
    throw UnimplementedError();
  }

  @override
  Future<void> addToCartd(String productId, int quantity, double price) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    bool exist = false;
    String cardId;
    int existQty;

    await cartCollection
        .where('userId', isEqualTo: uid)
        .where('productId', isEqualTo: productId)
        .get()
        .then((value) => {
              if (value.docs.length == 1)
                {
                  exist = true,
                  cardId = value.docs[0].id,
                  existQty = value.docs[0]['quantity']
                }
            });
    if (exist) {
      return cartCollection
          .doc(cardId)
          .update({'quantity': quantity + existQty})
          .then((value) => print("panier mis à jour"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      return cartCollection
          .add({
            'userId': uid,
            'productId': productId,
            'quantity': quantity,
            'price': price
          })
          .then((value) => {print('Cart Added')})
          .catchError((error) => {print('Failed to add cartd')});
    }
  }

  @override
  Future<void> deletedFromCard(String cartId) async {
    await cartCollection
        .doc(cartId)
        .delete()
        .then((value) => {print('successfully remove from cart')})
        .catchError((error) => {print(error)});
  }

  @override
  Future<void> setIsFavorite(String productId) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    bool exit = false;
    String docId;

    await favoritesCollection
        .where('productId', isEqualTo: productId)
        .get()
        .then((value) => {
              if (value.docs.length == 1)
                {exit = true, docId = value.docs[0].id}
            });

    if (exit) {
      return await favoritesCollection
          .doc(docId)
          .delete()
          .then((value) => {print('successfully remove from favorite')})
          .catchError((error) => {print(error)});
    } else {
      return await favoritesCollection
          .add({'userId': uid, 'productId': productId})
          .then((value) => {print("successfully add to favotires")})
          .catchError((error) => {print(error)});
    }
  }

  getCountProductCart() {
    final User user = auth.currentUser;
    final uid = user.uid;
    return cartCollection.where('userId', isEqualTo: uid).snapshots();
  }

  getCartAmount() {
    final User user = auth.currentUser;
    final uid = user.uid;
    return cartCollection.where('userId', isEqualTo: uid).snapshots();
  }

  setIncrementValue(int i) {
    return compteurCollection.doc('compteur').set({
      'increment': i + 1,
    }).then((value) => {print('incrementé')});
  }

  getIncrementValue() async {
    var incre;
    try {
      await compteurCollection
          .doc('compteur')
          .get()
          .then((value) => {incre = value['increment']});
    } catch (e) {
      print(e);
    }
    return incre;
  }

  void setAmouunt(double value) async {
    amount = value;
  }

  @override
  getCartStream() {
    final User user = auth.currentUser;
    final uid = user.uid;

    return cartCollection.where('userId', isEqualTo: uid).snapshots();
  }

  @override
  getFavProdStream() {
    final User user = auth.currentUser;
    final uid = user.uid;

    dynamic data =
        favoritesCollection.where('userId', isEqualTo: uid).snapshots();
    return data;
  }

  getCommandeProdStream() {
    final User user = auth.currentUser;
    final uid = user.uid;

    dynamic data =
        commandesCollection.where('userId', isEqualTo: uid).snapshots();
    return data;
  }

  Future<void> addToCommande() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    final String numFacture = "NF" + Random().nextInt(1000).toString();
    dynamic temp = await ProductDAO().getIncrementValue();
    int i = temp;
    // var zeroFilled = await ('000' + temp.toString()).substring(3);
    while ((temp.toString() + "").length < 3) {
      temp = "0" + temp.toString();
    }
    final String numCommande =
        "ZT" + f.format(DateTime.now()) + temp.toString();

    await cartCollection.where('userId', isEqualTo: uid).get().then((value) {
      print(value.docs.length);

      // print("data ${cartCollection.where('userId', isEqualTo: uid).snapshots()}");
      commandesCollection
          .add({
            'numCommande': numCommande,
            'userId': uid,
            'products': value.docs.map<Object>((e) => e.data()).toList(),
            'date': DateTime.now(),
            'status': "En cours de livraison",
            'facture': numFacture,
          })
          .then((value) => {setIncrementValue(i)})
          .catchError((error) => {print('Failed to add cartd')});
    });
  }
}
