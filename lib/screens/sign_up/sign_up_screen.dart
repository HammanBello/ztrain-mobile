import 'package:flutter/material.dart';
import 'package:shop_app/models/app_page.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.signUpScreen,
        key: ValueKey(AppPage.signUpScreen),
        child: SignUpScreen());
  }

  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S'inscrire"),
      ),
      body: Body(),
    );
  }
}
