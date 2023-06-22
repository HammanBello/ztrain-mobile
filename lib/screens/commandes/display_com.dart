import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/commande_model.dart';
import 'package:shop_app/screens/commandes/details_com.dart';

import '../../constants.dart';
import '../../models/Product.dart';
import '../../models/product_dao.dart';
import '../../size_config.dart';

final f = new DateFormat('ddMMyyyy');
var tempo;

class Display_com extends StatefulWidget {
  final Commande commandeProduct;

  const Display_com({
    Key key,
    this.commandeProduct,
  }) : super(key: key);

  @override
  State<Display_com> createState() => _Display_comState();
}

class _Display_comState extends State<Display_com> {
  Product product;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dynamic receiveProduct = await ProductDAO()
        .getProductById(widget.commandeProduct.productlist[0]['productId']);
        print("====================");
        print(receiveProduct);
        print("====================");
    dynamic temp = await ProductDAO().getIncrementValue();
    if (mounted) {
      setState(() {
        product = receiveProduct;
        tempo = temp;
      });
    }

 

  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        widget.commandeProduct.date.millisecondsSinceEpoch,
        isUtc: true);
    return product == null
        ? Center(child: CircularProgressIndicator())
        : ListTile(
          // ignore: unnecessary_statements
          trailing: IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  DetailsCom(productlist: widget.commandeProduct.productlist,),),);
          }, icon: Icon(Icons.add_circle),),
            // leading: Image.network(product.images[0]),
            title: Text(
              "Numéro de facture : " + widget.commandeProduct.facture,
              overflow: TextOverflow.ellipsis,
            ),
            // trailing:
            subtitle: SizedBox(
              height: 105,
              width: 70,
              child: Column(
                children: [
                  Text(
                    date.toUtc().toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   "commande: ${widget.commandeProduct.id}",
                  // ),
                  Text(
                    "commande:  ${widget.commandeProduct.numeroCom}",
                  ),
                  Text(
                    "Statut: ${widget.commandeProduct.status}",
                  ),
                ],
              ),
            ),
          ); /*  GestureDetector(
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
                        text: "${date.toLocal()}",
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
            )); */
  }
}
