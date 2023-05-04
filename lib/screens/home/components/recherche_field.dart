import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shop_app/constants.dart';

import '../../../size_config.dart';

class RechercheField extends StatelessWidget {
  final void Function(String val) searching;
   const RechercheField({Key key, double height, this.searching}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(getProportionateScreenWidth(10)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
      ),
      width: SizeConfig.screenWidth * 1,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) => searching(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(9),
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "Que recherchez vous ?",
          prefixIcon: Icon(Icons.search)
        ),
      ),
    );
  }
}