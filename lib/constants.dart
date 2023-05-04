import 'package:flutter/material.dart';
import 'package:shop_app/size_config.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp wordValidatorRegExp = RegExp(r"[a-zA-Z]+");
//final RegExp numtelValidatorRegExp = RegExp(r"^[0-9]");
final RegExp numtelValidatorRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
const String kEmailNullError = "Veuillez entrer votre email";
const String kInvalidEmailError = "Veuillez entrer une adresse email valide";
const String kPassNullError = "Veuillez entrer votre mot de passe";
const String kShortPassError =
    "Le mot de passe doit contenir au moins 8 caractères, 1 majuscule, 1 miniscule et un chiffre ";
const String kMatchPassError = "Les mots de passe ne sont pas identique";
const String kNamelNullError = "Veuillez entrer votre nom";
const String kPhoneNumberNullError =
    "Veuillez entrer votre numéro de téléphone";
const String kAddressNullError = "Veuillez entrer votre adresse";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
