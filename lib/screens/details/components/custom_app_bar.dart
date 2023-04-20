import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:shop_app/screens/home/components/icon_btn_with_counter.dart';

import '../../../size_config.dart';

class CustomAppBar extends PreferredSize {
  final double rating;

  CustomAppBar({@required this.rating});

  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  final Stream<QuerySnapshot> productCart = ProductDAO().getCountProductCart();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: productCart,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Row(
                children: [
                  SizedBox(
                      height: getProportionateScreenWidth(40),
                      width: getProportionateScreenWidth(40),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/icons/Back ICon.svg",
                          height: 15,
                        ),
                      )
                      // FlatButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(60),
                      // ),
                      //   color: Colors.white,
                      //   padding: EdgeInsets.zero,
                      //   onPressed: () => Navigator.pop(context),
                      // child: SvgPicture.asset(
                      //   "assets/icons/Back ICon.svg",
                      //   height: 15,
                      // ),
                      // ),
                      ),
                  Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    child: IconBtnWithCounter(
                        svgSrc: "assets/icons/Cart Icon.svg",
                        numOfitem: snapshot.data == null
                            ? 0
                            : snapshot.data.docs.length,
                        press: () {
                          Provider.of<AppStateManager>(context, listen: false)
                              .goToCart();
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
