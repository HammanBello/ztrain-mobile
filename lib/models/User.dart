import 'package:flutter/cupertino.dart';

class Profil {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String addressLiv;
  final String addressFac;
  final String genre;


  Profil(
      {@required this.id,
      @required this.firstName,
      this.lastName,
      @required this.phoneNumber,
      @required this.address,
      @required this.addressLiv,
      @required this.addressFac,
      @required this.genre});

  Profil.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        phoneNumber = json['phoneNumber'],
        address = json['address'],
        addressFac = json['addressFac'],
        genre = json['genre'],
        addressLiv = json['addressLiv'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
        'addressLiv': addressLiv,
        'addressFac': addressFac,
        'genre': genre
      };

  static toJsonMap(Object data) {}
}
