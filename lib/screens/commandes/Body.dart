import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/cart/components/empty_cart.dart';
import 'package:shop_app/screens/commandes/commandes_screen.dart';
import 'package:shop_app/screens/home/components/recherche_field.dart';

import '../../constants.dart';
import '../../models/commande_model.dart';
import '../../models/product_dao.dart';
import '../../size_config.dart';
import 'display_com.dart';
import 'empty_com.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final Stream<QuerySnapshot> _commandeStream =
      ProductDAO().getCommandeProdStream();
  List<Commande> commadesPRoducts = [];
  List _resultList = [];

  @override
  Widget build(BuildContext context) {
    // ProductDAO productDAO = Provider.of<ProductDAO>(context, listen: true);

    void _searchFournisseurData(String textSearch) async {
      if (textSearch == "") {
        setState(() {
          _resultList.clear();
        });
      } else {
        for (var i = 0; i < commadesPRoducts.length; i++) {
          if (commadesPRoducts[i].facture == textSearch) {
            setState(() {
              _resultList.add(commadesPRoducts[i]);
            });
          }
        }
      }
    }

    return StreamBuilder<QuerySnapshot>(
        stream: _commandeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if (snapshot.hasData) {
            commadesPRoducts.clear();
            snapshot.data.docs.forEach((doc) {
              Commande com = Commande(
                  id: doc.id,
                  userId: doc['userId'],
                  date: doc['date'],
                  productlist: doc['products'],
                  status: doc['status'],
                  facture: doc['facture'],
                  numeroCom: doc['numCommande']);
              commadesPRoducts.add(com);
            });
          }

          return snapshot.data.docs.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Container(
                    height: SizeConfig.screenHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RechercheField(
                          searching: _searchFournisseurData,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _resultList.length > 0
                                ? _resultList.length
                                : commadesPRoducts.length,
                            itemBuilder: (context, index) {
                              print(commadesPRoducts[index].id);
                              return Display_com(
                                commandeProduct: _resultList.length > 0
                                    ? _resultList[index]
                                    : commadesPRoducts[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : EmptyCommande();
        });
  }
}
