import 'package:flutter/cupertino.dart';

class Livreur{
  final String id;
  final String nom;

  Livreur({@required this.id, @required this.nom});

    Livreur.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nom = json['nom'];
        
 Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
      };

static toJsonMap(Object data) {}
  }

