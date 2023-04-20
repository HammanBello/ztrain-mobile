import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/models/app_page.dart';

import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.profileScreen,
        key: ValueKey(AppPage.profileScreen),
        child: ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
