import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/response.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/screens/sign_in/auth.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String conformPassword;
  bool remember = false;
  bool isLoading = false;
  bool isObscure = true;
  bool isObscureC = true;
  final List<String> errors = [];

  final _emailFormFieldController = TextEditingController();
  final _passwordFormFieldController = TextEditingController();
  final _confirmPasswordFormFieldController = TextEditingController();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _emailFormFieldController.dispose();
    _passwordFormFieldController.dispose();
    _confirmPasswordFormFieldController.dispose();
  }

  void removeError({String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void setLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continuer",
            isLoading: isLoading,
            press: () async {
              setLoading();
              setState(() {
                errors.clear();
              });
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Response res =
                    await auth.createUserWithEmailAndPassord(email, password);
                if (res.status == 200) {
                  setLoading();
                  Provider.of<AppStateManager>(context, listen: false).login();
                } else {
                  setLoading();
                  // print(res.error);
                  addError(error: res.error);
                }
              } else {
                setLoading();
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      controller: _confirmPasswordFormFieldController,
      obscureText: isObscureC,
      onSaved: (newValue) => conformPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirmer le mot de passe",
        hintText: "entrer le même mot de passe",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(isObscureC ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isObscureC = !isObscureC;
            });
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _passwordFormFieldController,
      obscureText: isObscure,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        print(value);
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (!passwordRegex.hasMatch(value)) {
          
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (!passwordRegex.hasMatch(value)) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe",
        hintText: "Entrer le mot de passe",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _emailFormFieldController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          print('email field change');

          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "exemple@gmail.com",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
