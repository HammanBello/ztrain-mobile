import 'package:flutter/material.dart';
import 'package:shop_app/models/app_page.dart';

import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  // static String routeName = "/login_success";
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.loginSuccesScreen,
        key: ValueKey(AppPage.loginSuccesScreen),
        child: LoginSuccessScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Login Success"),
      ),
      body: Body(),
    );
  }
}
