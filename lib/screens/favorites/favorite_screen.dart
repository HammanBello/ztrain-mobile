import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/models/app_page.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/screens/favorites/component/body.dart';

class FavoriteProduct extends StatefulWidget {
  static String routeName = "/favorite";
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.favoariteProductScreen,
        key: ValueKey(AppPage.favoariteProductScreen),
        child: FavoriteProduct());
  }

  const FavoriteProduct({Key key}) : super(key: key);

  @override
  _FavoriteProductState createState() => _FavoriteProductState();
}

class _FavoriteProductState extends State<FavoriteProduct> {
  final Stream<QuerySnapshot> _favoriteProductStream =
      ProductDAO().getFavProdStream();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _favoriteProductStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
              appBar: buildAppBar(context),
              body: Body(),
              bottomNavigationBar:
                  CustomBottomNavBar(selectedMenu: MenuState.favourite),
              floatingActionButton:
                  snapshot.data != null && snapshot.data.docs.isNotEmpty
                      ? FloatingActionButton.extended(
                          onPressed: () {
                            snapshot.data.docs.forEach((doc) {
                              ProductDAO().setIsFavorite(doc['productId']);
                            });
                          },
                          label: Text('vider'),
                          icon: Icon(Icons.delete),
                          backgroundColor: kPrimaryColor,
                        )
                      : null);
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Favoris",
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}
