import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/helper/response.dart';
import 'package:shop_app/models/User.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<Response> updateProfil(userId, data) {
  return users.doc(userId).set(data).then((value) =>
      Response(status: 200, message: 'Utilisateur ajouté avec succès'));
}

Future<Profil> getUser(userId) {
  return users.doc(userId).get().then((DocumentSnapshot documentSnapshot) =>
      Profil.fromJson(documentSnapshot.data()));
}

