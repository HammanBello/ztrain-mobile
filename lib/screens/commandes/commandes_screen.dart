import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shop_app/models/app_page.dart';
import 'package:shop_app/screens/commandes/Body.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
//import '../../models/app_page.dart';
import '../../enums.dart';
import '../../models/product_dao.dart';
import '../../size_config.dart';
import 'empty_com.dart';


class Commandes extends StatefulWidget {
  static String routeName = "/commandes";
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.commandesScreen,
        key: ValueKey(AppPage.commandesScreen),
        child: Commandes());
  }

  //const Commandes({Key key}) : super(key: key);

  @override
  _CommandesState createState() => _CommandesState();
}


class _CommandesState extends State<Commandes> {
  final Stream<QuerySnapshot> _commandeStream =
      ProductDAO().getCommandeProdStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _commandeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
              appBar:  AppBar(
              title: Text("Mes Commandes", style: headingStyle), 
              ),
               body: Body(),
              // floatingActionButton:
              //     snapshot.data != null && snapshot.data.docs.isNotEmpty
              //         ? FloatingActionButton.extended(
              //             onPressed: () {
              //               snapshot.data.docs.forEach((doc) {
              //                 ProductDAO().getCommandeProdStream();
              //               });
              //             },
              //             label: Text('vider'),
              //             icon: Icon(Icons.delete),
              //             backgroundColor: kPrimaryColor,
              //           )
              //         : EmptyCommande()
                      );
        });
  }
}
