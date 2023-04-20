import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/size_config.dart';

import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final Product product;
  final int quantity;
  const Body({Key key, @required this.product, this.quantity})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final ProductDAO productDAO =
        Provider.of<ProductDAO>(context, listen: false);

    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 0) {
                                      --quantity;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove)),
                            Text('$quantity'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity < 10) {
                                      ++quantity;
                                    }
                                  });
                                },
                                icon: Icon(Icons.add))
                          ],
                        ),
                      ),
                    ),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: "Ajouter au panier",
                          press: () {
                            if (quantity == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Indiquez le nombre d\'article')));
                            } else {
                              print(widget.quantity);
                              if (widget.quantity == null) {
                                productDAO.addToCartd(widget.product.id,
                                    quantity, widget.product.price);
                              } else {
                                productDAO.addToCartd(
                                    widget.product.id,
                                    quantity + widget.quantity,
                                    widget.product.price);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Panier mis à jours')));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
