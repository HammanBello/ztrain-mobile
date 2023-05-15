import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/screens/cart/components/empty_cart.dart';

import '../../../size_config.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final Stream<QuerySnapshot> _cartStream = ProductDAO().getCartStream();
  List<Cart> carts = [];
  var datas = null;
  @override
  void initState() {
    super.initState();
    // loadData();
  }

  loadData() async {
    dynamic results = await ProductDAO().getProductForCart();
    setState(() {
      carts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductDAO productDAO = Provider.of<ProductDAO>(context, listen: true);
    return StreamBuilder<QuerySnapshot>(
        stream: _cartStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null && snapshot.data != datas) {
            carts.clear();
            snapshot.data.docs.forEach((doc) {
              Cart cart = Cart(
                  id: doc.id,
                  userId: doc['userId'],
                  productId: doc['productId'],
                  quantity: doc['quantity'],
                  price: doc['price']);
              carts.add(cart);
            });
          }
          datas = snapshot.data;
          return snapshot.data != null && snapshot.data.docs.isEmpty
              ? EmptyCart()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          productDAO.deletedFromCard(carts[index].id);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('retirer du panier')));
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
                        child: CartCard(cart: carts[index]),
                      ),
                    ),
                  ),
                );
        });
  }
}
