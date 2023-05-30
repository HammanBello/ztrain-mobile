import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/app_page.dart';
import 'package:shop_app/models/product_dao.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.cartScreen,
        key: ValueKey(AppPage.cartScreen),
        child: CartScreen());
  }

  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _cartStream = ProductDAO().getCartStream();
    return StreamBuilder<QuerySnapshot>(
        stream: _cartStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Expanded(
            child: Scaffold(
                appBar: buildAppBar(context),
                body: Body(),
                bottomNavigationBar: CheckoutCard(),
                floatingActionButton:
                    snapshot.data != null && snapshot.data.docs.isNotEmpty
                        ? FloatingActionButton.extended(
                            onPressed: () {
                              snapshot.data.docs.forEach((doc) {
                                ProductDAO().deletedFromCard(doc.id);
                              });
                            },
                            
                            label: Text('vider le panier'),
                            icon: Icon(Icons.delete),
                            backgroundColor: kPrimaryColor,
                          )
                        
                

                        : null),
          );
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Votre panier",
            style: TextStyle(color: Colors.black),
          ),
          // Text(
          //   "${demoCarts.length} items",
          //   style: Theme.of(context).textTheme.caption,
          // ),
        ],
      ),
    );
  }
}
