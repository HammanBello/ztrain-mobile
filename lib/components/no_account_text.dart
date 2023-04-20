import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/app_state_manager.dart';
// import 'package:shop_app/screens/sign_up/sign_up_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Vous n'avez pas de compte ? ",
              style: TextStyle(fontSize: getProportionateScreenWidth(16)),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, SignUpScreen.routeName);
                print('tests');
                Provider.of<AppStateManager>(context, listen: false)
                    .setOnCreatingAccount(true);
              },
              child: Text(
                "S'inscrire",
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    color: kPrimaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
