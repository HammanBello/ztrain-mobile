import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/app_product_manager.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/models/product_dao.dart';
// import 'package:shop_app/screens/details/details_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key key,
    this.width = 140,
    this.aspectRetio = 1.02,
    @required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Stream<QuerySnapshot> favoriteProduct;
  @override
  Widget build(BuildContext context) {
    ProductDAO productDAO = Provider.of<ProductDAO>(context);
    favoriteProduct = productDAO.getFavProdStream();

    return StreamBuilder<QuerySnapshot>(
        stream: favoriteProduct,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
            child: SizedBox(
              width: getProportionateScreenWidth(widget.width),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(
                  //   context,
                  //   DetailsScreen.routeName,
                  //   arguments: ProductDetailsArguments(product: widget.product),
                  // );
                  Provider.of<AppProductManager>(context, listen: false)
                      .selectProduct(widget.product);
                  Provider.of<AppStateManager>(context, listen: false)
                      .setDisplayProduct(true);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.02,
                      child: Container(
                        padding:
                            EdgeInsets.all(getProportionateScreenWidth(20)),
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Hero(
                          tag: widget.product.id,
                          child: Image.network(widget.product.images[0]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.title,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\€${widget.product.price}",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            productDAO.setIsFavorite(widget.product.id);
                          },
                          child: Container(
                            padding:
                                EdgeInsets.all(getProportionateScreenWidth(8)),
                            height: getProportionateScreenWidth(28),
                            width: getProportionateScreenWidth(28),
                            decoration: BoxDecoration(
                              color: snapshot.data != null &&
                                      snapshot.data.docs
                                          .where((element) =>
                                              element['productId'] ==
                                              widget.product.id)
                                          .toList()
                                          .isEmpty
                                  ? kSecondaryColor.withOpacity(0.1)
                                  : kPrimaryColor.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/Heart Icon_2.svg",
                              color: snapshot.data != null &&
                                      snapshot.data.docs
                                          .where((element) =>
                                              element['productId'] ==
                                              widget.product.id)
                                          .toList()
                                          .isEmpty
                                  ? Color(0xFFDBDEE4)
                                  : Color(0xFFFF4848),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
