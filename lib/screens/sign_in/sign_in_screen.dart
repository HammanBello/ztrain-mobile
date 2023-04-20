import 'package:flutter/material.dart';
import 'package:shop_app/models/app_page.dart';

import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: AppPage.signInScreen,
      key: ValueKey(AppPage.signInScreen),
      child: SignInScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Se Connecter"),
      ),
      body: Body(),
    );
  }
}
