import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/screens/favorites/component/display_fav.dart';
import 'package:shop_app/screens/favorites/component/empty_fav.dart';
import 'package:shop_app/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final Stream<QuerySnapshot> _favoriteProductStream =
      ProductDAO().getFavProdStream();
  List<Favorite> favoritePRoducts = [];

  @override
  Widget build(BuildContext context) {
    ProductDAO productDAO = Provider.of<ProductDAO>(context, listen: true);

    return StreamBuilder<QuerySnapshot>(
        stream: _favoriteProductStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if (snapshot.data != null) {
            favoritePRoducts.clear();
            snapshot.data.docs.forEach((doc) {
              Favorite fav =
                  Favorite(userId: doc['userId'], productId: doc['productId']);
              favoritePRoducts.add(fav);
            });
          }

          return snapshot.data.docs.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: ListView.builder(
                    itemCount: favoritePRoducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            productDAO.setIsFavorite(
                                favoritePRoducts[index].productId);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'vous avez retiré ce produit de vos favoris')));
                          },
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
                          child: DisplayFav(
                            favoriteProduct: favoritePRoducts[index],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : EmptyFav();
        });
  }
}
