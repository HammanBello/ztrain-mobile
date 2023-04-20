import 'package:flutter/material.dart';
import 'package:shop_app/models/app_page.dart';

import '../../constants.dart';
import 'components/body.dart';

class EditProfileScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: AppPage.editProfileScreen,
        key: ValueKey(AppPage.editProfileScreen),
        child: EditProfileScreen());
  }

  static String routeName = "/edit_profile";
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes informations", style: headingStyle),
      ),
      body: Body(),
    );
  }
}
