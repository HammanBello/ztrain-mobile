import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/size_config.dart';

class DisplayFav extends StatefulWidget {
  final Favorite favoriteProduct;
  const DisplayFav({Key key, this.favoriteProduct}) : super(key: key);

  @override
  State<DisplayFav> createState() => _DisplayFavState();
}

class _DisplayFavState extends State<DisplayFav> {
  Product product;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dynamic receiveProduct =
        await ProductDAO().getProductById(widget.favoriteProduct.productId);
    if (mounted) {
      setState(() {
        product = receiveProduct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? Center(child: CircularProgressIndicator())
        : GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 70,
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
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 245,
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
                          // TextSpan(
                          //     text: " x${widget.cart.quantity}",
                          //     style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ));
  }
}
