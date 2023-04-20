import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app/models/Product.dart';

class CommandeModel extends ChangeNotifier {
  final List<Commande> _items = [];
  final CollectionReference commandesCollection =
      FirebaseFirestore.instance.collection('commandes');
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Commande> get items => List.from(_items);

  void favotise(String productId) {
    //setIsFavorite(productId);
    notifyListeners();
  }

  Future<dynamic> getData() async {
    final User user = auth.currentUser;
    final uid = user.uid;
    await commandesCollection
        .where('userId', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                Commande com = Commande(
                  id: doc.id,
                  userId: doc['userId'],
                  productlist: doc['products'],
                  date: doc['date'],
                  status: doc['status'],
                );
                _items.add(com);
                notifyListeners();
              })
            })
        .catchError((error) => {print(error)});
    return _items;
  }

//   Future<void> setIsFavorite(String productId) async {
//     final User user = auth.currentUser;
//     final uid = user.uid;
//     bool exit = false;
//     String docId;

//     await commandesCollection
//         .where('productId', isEqualTo: productId)
//         .get()
//         .then((value) => {
//               if (value.docs.length == 1)
//                 {exit = true, docId = value.docs[0].id}
//             });

//     if (exit) {
//       return await commandesCollection
//           .doc(docId)
//           .delete()
//           .then((value) => {print('successfully remove from favorite')})
//           .catchError((error) => {print(error)});
//     } else {
//       return await commandesCollection
//           .add({'userId': uid, 'productId': productId})
//           .then((value) => {print("successfully add to favotires")})
//           .catchError((error) => {print(error)});
//     }
//   }
}

class Commande {
  String id;
  final String userId;
  final List<dynamic> productlist;
  final Timestamp date;
  final String facture;
  final String numCom;
  final String status;

  Commande(
      {this.facture,
      this.numCom,
      this.status,
      this.id,
      @required this.userId,
      @required this.productlist,
      @required this.date});
}
