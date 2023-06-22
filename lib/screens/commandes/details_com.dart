import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/screens/cart/components/empty_cart.dart';

import '../../../size_config.dart';
import '../../constants.dart';
import '../cart/components/cart_card.dart';

class DetailsCom extends StatefulWidget {

  final List<dynamic> productlist;
 

  const DetailsCom({Key key, this.productlist}) : super(key: key);
  @override
  _DetailsComState createState() => _DetailsComState();
}

class _DetailsComState extends State<DetailsCom> {
  final Stream<QuerySnapshot> _cartStream = ProductDAO().getCartStream();
  
  var carts = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    List<dynamic> results = [];
    for (var i = 0; i < widget.productlist.length; i++) {
     dynamic result = await ProductDAO().getProductById(widget.productlist[i]['productId']);
      results.add(result);
    }
    setState(() {
      carts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return carts.isEmpty
              ? EmptyCart()
              : Scaffold(
                appBar:  AppBar(
              title: Text("Détails", style: headingStyle), 
              ),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
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
                      child: Image.network(carts[index].images[0]),
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
                        carts[index]?.title,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "\€${carts[index].price}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: kPrimaryColor),
                        children: [
                          TextSpan(
                              text: " x${widget.productlist[index]['quantity']}",
                              style: Theme.of(context).textTheme.bodyText1),

                          TextSpan(text: "\nTotal:\n", children: [
                          TextSpan(
                            text: "${carts[index].price * widget.productlist[index]['quantity']}",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ]),
                        ],
                        
                      ),
                    )
                  ],
                )
                ],
                        ),
                    ),
                  ),
                ),
              ); 
        }




     
     



  }

