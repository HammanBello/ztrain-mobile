import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/models/product_dao.dart';
// import 'package:shop_app/screens/cart/cart_screen.dart';

import '../../../firestoreService/userService.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'icon_btn_with_counter_active.dart';
import 'search_field.dart';

class HomeHeader extends StatefulWidget {
  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int numCartProduct;

  final Stream<QuerySnapshot> productCart = ProductDAO().getCountProductCart();
  final FirebaseAuth auth = FirebaseAuth.instance;
 String lastname = 'Inconnu' ;
 String genre = 'Monsieur' ;

  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;
    setName(user);
  }

  setName(user) async {
    final resp = await getUser(user.uid) ; 
    setState(() {
      if(resp.lastName.isNotEmpty){
        lastname = resp.lastName;
        genre = resp.genre;
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
     final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: productCart,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: getProportionateScreenWidth(40)),
              SearchField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconBtnWithCounterActive(
                svgSrc: genre == 'Monsieur' ?  "assets/icons/man-user-svgrepo-com.svg" : "assets/icons/woman-user-svgrepo-com.svg" ,
                // numOfitem:
                //     snapshot.data == null ? 0 : snapshot.data.docs.length,
                // numOfitem:
                //      0,
                press: () {
                   appStateManager.setModifyPlofil(true);
                },
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
                  IconBtnWithCounter( 
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem:
                    snapshot.data == null ? 0 : snapshot.data.docs.length,
                press: () {
                  // Provider.of<AppStateManager>(context, listen: false)
                  //     .setDisplayProduct(false);
                  Provider.of<AppStateManager>(context, listen: false)
                      .goToCart();
                  // Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
              
              ],),  
               
            ],
          ),
        );
      },
    );
  }
}
