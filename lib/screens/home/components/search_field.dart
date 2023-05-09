import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/firestoreService/userService.dart';
import 'package:shop_app/helper/response.dart';
import 'package:shop_app/models/User.dart';
import 'dart:developer';

import '../../../constants.dart';
import '../../../models/app_state_manager.dart';
import '../../../size_config.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String lastname = 'Inconnu';
  String genre = 'Monsieur';

  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;
    setName(user);
  }

  setName(user) async {
    final resp = await getUser(user.uid);
    setState(() {
      if (resp.lastName.isNotEmpty) {
        lastname = resp.lastName;
        genre = resp.genre;
      }
    });
  }

  List<DropdownMenuItem<String>> list = [];
  String def;

  void menu() {
    list.clear();
    list.add(DropdownMenuItem(
        value: 'Mon Compte',
        child: Text(
          'Mon Compte',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
        )));
    list.add(DropdownMenuItem(
        value: 'Mes Commandes',
        child: Text(
          'Mes Commandes',
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.black),
        )));
  }

  @override
  Widget build(BuildContext context) {
    menu();
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context);
    return Container(
      width: SizeConfig.screenWidth * 0.5,

      // decoration: BoxDecoration(
      //   color: kSecondaryColor.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(15),
      // ),
      // child: TextFormField(
      //   //lastname
      //   //onChanged: (value) => print(value),
      //   decoration: InputDecoration(
      //       contentPadding: EdgeInsets.symmetric(
      //           horizontal: getProportionateScreenWidth(20),
      //           vertical: getProportionateScreenWidth(9)),
      //       border: InputBorder.none,
      //       focusedBorder: InputBorder.none,
      //       enabledBorder: InputBorder.none,
      //       hintText: lastname,
      //       enabled: false,

      //       ),

      //     onTap: () {print("I'm here!!!");
      //     appStateManager.setModifyPlofil(true);},

      // ),
      child: Align(
          alignment: Alignment.topRight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DropdownButton(
              value: def,
              elevation: 10,
              items: list,
              hint: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  appStateManager.lastname,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.end,
                ),
              ),
              underline: SizedBox(),
              iconSize: 0.0,
              onChanged: (value) {
                if (value == 'Mon Compte') {
                  appStateManager.setModifyPlofil(true);
                }
                if (value == 'Mes Commandes') {
                  appStateManager.setCommande(true);
                }
              },
            ),
          )),
    );
  }
}
