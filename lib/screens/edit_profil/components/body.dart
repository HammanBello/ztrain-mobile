import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

import 'edit_profile_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: SizeConfig.screenHeight * 0.03),
                // Text("Vos Informations", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                EditProfileForm(),
                SizedBox(height: getProportionateScreenHeight(30)),
                // Text(
                //   "En continuant, vous confirmez que vous êtes d'accord \navec nos conditions générales.",
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.caption,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
