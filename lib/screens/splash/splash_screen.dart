import 'package:flutter/material.dart';
import 'package:shop_app/models/app_page.dart';
import 'package:shop_app/screens/splash/components/body.dart';
import 'package:shop_app/size_config.dart';

class SplashScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.splashScreen,
        key: ValueKey(AppPage.splashScreen),
        child: SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
