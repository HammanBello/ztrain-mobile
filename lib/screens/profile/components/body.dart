import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/app_state_manager.dart';
// import 'package:shop_app/screens/edit_profil/edit_profile_screen.dart';
import 'package:shop_app/screens/sign_in/auth.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
              text: "Mon compte",
              icon: "assets/icons/User Icon.svg",
              press: () {
                appStateManager.setModifyPlofil(true);
              }),
          // ProfileMenu(
          //   text: "Notifications",
          //   icon: "assets/icons/Bell.svg",
          //   press: () {},
          // ),
          // ProfileMenu(
          //   text: "Configurations",
          //   icon: "assets/icons/Settings.svg",
          //   press: () {},
          // ),
          // ProfileMenu(
          //   text: "Aide",
          //   icon: "assets/icons/Question mark.svg",
          //   press: () {},
          // ),
          ProfileMenu(
            text: "Déconnexion",
            icon: "assets/icons/Log out.svg",
            press: () {
              try {
                auth.signOut().then((value) {
                  appStateManager.logOut();
                });
                // Navigator.pushNamed(context, SignInScreen.routeName);
              } on FirebaseAuthException catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }
}
