import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/app_product_manager.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/models/product_dao.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);
  final Cart cart;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  Product product;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dynamic receiveProduct =
        await ProductDAO().getProductById(widget.cart.productId);
    if (mounted) {
      setState(() {
        product = receiveProduct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    AppProductManager appProductManager =
        Provider.of<AppProductManager>(context, listen: false);
    return product == null
        ? Center(child: CircularProgressIndicator())
        : GestureDetector(
            onTap: () {
              appProductManager
                  .setSelectedProductQuantity(widget.cart.quantity);
              appProductManager.selectProduct(product);
              appStateManager.setCart(false);
              appStateManager.setDisplayProduct(true);
              // Navigator.pushNamed(
              //   context,
              //   DetailsScreen.routeName,
              //   arguments: ProductDetailsArguments(
              //       product: product, quantity: widget.cart.quantity),
              // );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  child: AspectRatio(
                    aspectRatio: 0.88,
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.network(product?.images[0]),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 215,
                      child: Text(
                        product?.title,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "\€${product?.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: kPrimaryColor),
                        children: [
                          TextSpan(
                              text: " x${widget.cart.quantity}",
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
