import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/no_account_text.dart';
import 'package:shop_app/components/socal_card.dart';
import 'package:shop_app/helper/response.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/screens/sign_in/auth.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () async {
                        Response resp = await auth.signInWithGoogle();
                        print('test ${resp.status}');
                        if (resp.status == 200) {
                          Provider.of<AppStateManager>(context, listen: false)
                              .login();
                        }
                      },
                    ),
                    // SocalCard(
                    //   icon: "assets/icons/facebook-2.svg",
                    //   press: () async {
                    //     var resp = await auth.signInWithFacebook();
                    //     if (resp.status == 200) {
                    //       // Navigator.pushNamed(
                    //       //     context, LoginSuccessScreen.routeName);
                    //     }
                    //     print(resp);
                    //   },
                    // ),
                    // SocalCard(
                    //   icon: "assets/icons/twitter.svg",
                    //   press: () {},
                    // ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
