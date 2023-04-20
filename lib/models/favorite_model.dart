import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FavoriteModel extends ChangeNotifier {
  final List<Favorite> _items = [];
  final CollectionReference favoritesCollection =
      FirebaseFirestore.instance.collection('Favorites');
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Favorite> get items => List.from(_items);

  void favotise(String productId) {
    setIsFavorite(productId);
    notifyListeners();
  }

  Future<dynamic> getData() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    await favoritesCollection
        .where('userId', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                Favorite favorite = Favorite(
                    id: doc.id,
                    userId: doc['userId'],
                    productId: doc['productId']);
                _items.add(favorite);
                notifyListeners();
              })
            })
        .catchError((error) => {print(error)});
    return _items;
  }

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
}

class Favorite {
  String id;
  final String userId;
  final String productId;

  Favorite({this.id, @required this.userId, @required this.productId});
}
