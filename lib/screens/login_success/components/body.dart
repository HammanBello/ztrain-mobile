import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Center(
          child: Image.asset(
            "assets/images/success.png",
            fit: BoxFit.fill,
            // height: SizeConfig.screenHeight * 0.4, //40%
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Vous y êtes",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Aller au site",
            press: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .loginSucess();
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
