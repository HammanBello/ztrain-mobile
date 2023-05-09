import 'package:country_state_picker/country_state_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/firestoreService/userService.dart';
import 'package:shop_app/helper/response.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:shop_app/models/User.dart';
import 'package:select_form_field/select_form_field.dart';
import '../components/body.dart';
import '../../../constants.dart';
import '../../../models/app_state_manager.dart';
import '../../../models/app_tab.dart';
import '../../../size_config.dart';
import '../../home/home_screen.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressFacController = TextEditingController();
  TextEditingController addressLivController = TextEditingController();
  TextEditingController newpwdController = TextEditingController();
  TextEditingController genreController = TextEditingController();

  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  String addressLiv;
  String addressFac;
  String userId;
  String genre;
  String state;
  String country;

  // Profil profil;
  bool isLoading = false;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void setLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;
    setState(() {
      userId = user.uid;
    });
    loadProfil(userId);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    addressController.dispose();
    addressFacController.dispose();
    addressLivController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    genreController.dispose();
    super.dispose();
  }

  loadProfil(userId) async {
    final resp = await getUser(userId);
    setState(() {
      lastNameController.text = resp.lastName;
      phoneNumberController.text = resp.phoneNumber;
      addressController.text = resp.address;
      addressFacController.text = resp.addressFac;
      addressLivController.text = resp.addressLiv;
      firstNameController.text = resp.firstName;
      genreController.text = resp.genre;
    });
  }

  Future<void> openDialog(BuildContext ctx) async {
    switch (await showDialog(
      context: ctx,
      builder: (ctx) => SimpleDialog(
        children: [
          Container(
              height: 260,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('Votre compte a été mofifié avec succès'),
                  ),
                  SizedBox(
                    // margin: EdgeInsets.only(top: 30),
                    child: DefaultButton(
                      text: "Ok",
                      press: () {
                        print("ca a cliqué");
                        Navigator.pop(ctx);
                        // Navigator.pop(context, true);
                        // Provider.of<AppStateManager>(context, listen: true)
                        //     .loginSucess();
                        Provider.of<AppStateManager>(context, listen: false)
                            .setModifyPlofil(false);
                        Provider.of<AppStateManager>(context, listen: false)
                            .goToTab(AppTab.home);
                        // Navigator.pushReplacementNamed(
                        //   context,
                        //   "/home",
                        // );
                      },
                      //=> Navigator.pop(context, true),
                    ),
                  )
                ]),
              ))
        ],
      ),
    )) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return Form(
      key: _formKey,
      child: Column(
        children: [
         buildgenderFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildfirstNameFormField(firstName),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(lastName),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(phoneNumber),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(user.email),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildpwdFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressfacturationFormField(addressFac),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressLivraisonFormField(addressLiv),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(address),
          
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Modifier",
            isLoading: isLoading,
            press: () async {
              setLoading();

              if (newpwdController.text.isNotEmpty) {
                user.updatePassword(newpwdController.text);
              }
              if (_formKey.currentState.validate()) {
                Response resp = await updateProfil(userId, {
                  // 'id': userId,
                  // 'first_name': firstName,
                  // 'last_name': lastName,
                  // 'phoneNumber': phoneNumber,
                  // 'address': address,
                  // 'addressFac': addressFac,
                  // 'addressLiv': addressLiv,
                  'id': userId,
                  'first_name': firstNameController.text,
                  'last_name': lastNameController.text,
                  'phoneNumber': phoneNumberController.text,
                  'address': addressController.text,
                  'addressFac': addressFacController.text,
                  'addressLiv': addressLivController.text,
                  'genre': genreController.text
                });
                if (resp?.status == 200) {
                  //Provider.of<AppStateManager>(context, listen: false)
                  //       .loginFalse();

                  openDialog(context);
                  // setLoading();
                }
              }
              setLoading();
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField(ct) {
    return TextFormField(
      controller: addressController,
      //initialValue: addressValue,
      onSaved: (newValue) => addressController.text = newValue,
      onChanged: (value) => setState(() {
        address = value;
      }),
      validator: (value) {
        if (value.isEmpty) {
          addError(error: " le champ adresse est vide");
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        addressController.text = value;
        return null;
      },
      decoration: InputDecoration(
        labelText: "Pays",
        hintText: "Saisir votre Pays",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );


  //   return  CountryStatePicker(
  //   countryLabel: Text(""),
  //   stateLabel: Text(""),
  //           onCountryChanged: (ct) => setState(() {
  //            addressController.text = ct;
  //           country = ct;
  //           if (ct.isEmpty) {
  //         addError(error: " le champ adresse est vide");
  //         return "";
  //       } else if (!wordValidatorRegExp.hasMatch(ct)) {
  //         addError(error: "Certaines valeurs ne sont pas valides");
  //         return "";
  //       }
  //           addressController.text = ct;
  //           state = null; 
  //           }),
  //           onStateChanged: (st) => setState(() {
  //             state = st;
  //             if (st.isEmpty) {
  //         addError(error: " le champ adresse est vide");
  //         return "";
  //       } else if (!wordValidatorRegExp.hasMatch(st)) {
  //         addError(error: "Certaines valeurs ne sont pas valides");
  //         return "";
  //       }
  //       addressController.text = ct;
  //       return null;
  //     },
     
  //  ),
  //  inputDecoration: InputDecoration(
  //       labelText: "Adresse",
  //       hintText:  "Entrez l'adresse",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       // suffixIcon:
  //       //     CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
  //     ),
  //  );

  }

  TextFormField buildAddressfacturationFormField(addressValue) {
    return TextFormField(
      controller: addressFacController,
      //initialValue: addressValue,
      onSaved: (newValue) => addressFac = newValue,
      onChanged: (value) => setState(() {
        addressFac = value;
      }),
      validator: (value) {
        if (value.isEmpty) {
          addError(error: " le champ adresse est vide");
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        addressFacController.text = value;
        return null;
      },
      decoration: InputDecoration(
        labelText: "Adresse de facturation",
        hintText: "Entrez l'adresse de facturation",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildAddressLivraisonFormField(addressValue) {
    return TextFormField(
      controller: addressLivController,
      //initialValue: addressValue,
      onSaved: (newValue) => addressLiv = newValue,
      onChanged: (value) => setState(() {
        addressLiv = value;
      }),
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "le champ adresse est vide");
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        addressLivController.text = value;
        return null;
      },
      decoration: InputDecoration(
        labelText: "Adresse de livraison",
        hintText: "Entrez l'adresse de livraison",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(phone) {
    return TextFormField(
      controller: phoneNumberController,
      // initialValue: phone,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) => setState(() {
        phoneNumber = value;
      }),
      decoration: InputDecoration(
        labelText: "Numéro",
        hintText: phone != null ? phone : "Entrez le numéro de téléphone",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
      validator: (value) {
        // if (value.isEmpty) {
        //   addError(error: "Entrez un numéro de téléphone");
        //   return "";
        // } else
        if (!numtelValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        phoneNumberController.text = value;
        return null;
      },
    );
  }

  TextFormField buildLastNameFormField(lastNameValue) {
    return TextFormField(
      controller: lastNameController,
      // initialValue: lastNameValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            lastName = value;
          });
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "le champ prénom est vide");
          return "";
        } else if (!lastNameValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        if (value.length > 20) {
          addError(error: "Le champs prenom est limité à 20 caractères");
          return "";
        }
        if (RevertlastNameValidatorRegExp.hasMatch(value)) {
          addError(
              error: "Le champs prenom ne prends pas de caractères numériques");
          return "";
        }
        lastNameController.text = value;
        return null;
      },
      decoration: InputDecoration(
        labelText: "Prénom",
        hintText: "Entrez le prénom",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildfirstNameFormField(name) {
    return TextFormField(
      controller: firstNameController,
      // initialValue: name,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            firstName = value;
          });
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "le champ nom est vide");
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        firstNameController.text = value;
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nom",
        hintText: "Entrez le nom",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

    TextFormField buildEmailFormField(email) {
    return TextFormField(
     initialValue: email,
     enabled: false,
      decoration: InputDecoration(
        labelText: "E-MAIL",
        hintText:  "Entrez le mail",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildpwdFormField() {
    return TextFormField(
      controller: newpwdController,
      obscureText: !_obscureText,
      // initialValue: name,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            firstName = value;
          });
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        // if (value.isEmpty) {
        //   //addError(error: "le champ nom est vide");
        //   return "";
        // } else
        if (value.isNotEmpty & !passwordRegex.hasMatch(value)) {
          addError(error: kShortPassError);
          return "";
        }

        if (value.isNotEmpty) newpwdController.text = value;
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nouveau mot de passe",
        hintText: "Entrez le nouveau mot de passe",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,

        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child:
              new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

// ignore: non_constant_identifier_names

  DropdownButtonFormField buildgenderFormField() {
    final name = genreController.text;
    return DropdownButtonFormField(
      // initialValue: name,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            genreController.text = value;
          });
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        // if (value.isEmpty) {
        //   addError(error: "le champ nom est vide");
        //   return "";
        // } else if (!wordValidatorRegExp.hasMatch(value)) {
        //   addError(error: "Certaines valeurs ne sont pas valides");
        //   return "";
        // }
        //newpwdController.text = value;
        return null;
      },

      decoration: InputDecoration(
        labelText: "Genre",
        hintText: name != null ? name : "Choisissez votre genre",

        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,

        //suffixIcon:  CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
      items: <String>['Monsieur', 'Madame']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        );
      }).toList(),
    );
  }

  bool _obscureText = false;
}
