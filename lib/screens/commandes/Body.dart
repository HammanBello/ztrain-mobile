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
  @override
  Widget build(BuildContext context) {
    ProductDAO productDAO = Provider.of<ProductDAO>(context, listen: true);

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
                  status: doc['status']);
              commadesPRoducts.add(com);
            });
          }

          return snapshot.data.docs.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: ListView.builder(
                    itemCount: commadesPRoducts.length,
                    itemBuilder: (context, index) {
                      print(commadesPRoducts[index].id);
                      return ListTile(
                        title: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          // onDismissed: (direction) {
                          //   productDAO.setIsFavorite(
                          //       commadesPRoducts[index].productlist.);
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //       content: Text(
                          //           'vous avez retiré ce produit de vos favoris')));
                          // },
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ],
                            ),
                          ),
                          child: Display_com(
                            commandeProduct: commadesPRoducts[index],
                            indice : index,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : EmptyCommande();
        });
  }
}
