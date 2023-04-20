import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/product_dao.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  List<Product> productList = [];
  List<Favorite> userFavoriteProduct = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteProduct();
    loadData();
  }

  loadData() async {
    dynamic results = await ProductDAO().getAllProduct();
    if (mounted) {
      setState(() {
        productList = results;
      });
    }
  }

  void loadFavoriteProduct() async {
    List<Favorite> fav = await FavoriteModel().getData();
    if (mounted) {
      setState(() {
        userFavoriteProduct = fav;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ProductDAO productDAO = Provider.of<ProductDAO>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Tendances", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (Product product in productList) ProductCard(product: product)
            ],
          ),
        )
      ],
    );
  }
}
