import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/app_tab.dart';

import '../firestoreService/userService.dart';

class  AppStateManager extends ChangeNotifier {
  bool _isSplashed = false;
  bool _isLogin = false;
  bool _logInSucess = false;
  int  _selectedTab = AppTab.home;
  bool _displayProduct = false;
  bool _displayCommandes = false;
  bool _displayCart = false;
  bool _displayModifyProfil = false;
  bool _onCreatingAccount = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _svgSrc;
  String _lastname;

  bool get isLogin => _isLogin;
  int  get selectTab => _selectedTab;
  bool get logInSucess => _logInSucess;
  bool get isSplashed => _isSplashed;
  bool get displayProduct => _displayProduct;
  bool get displayCart => _displayCart;
  bool get displayModifyProfil => _displayModifyProfil;
  bool get displayCommandes => _displayCommandes;
  bool get onCreatingAccout => _onCreatingAccount;
  String get svgSrc {
    setName(); 
    return _svgSrc;
    }
  String get lastname {
    setName(); 
    return _lastname;
    }


   void setName() async {
    var user = auth.currentUser;
    var genre;
    final resp = await getUser(user.uid) ; 
      if(resp.lastName.isNotEmpty){
        _lastname = resp.lastName;
        genre = resp.genre;
      }
      _svgSrc = genre == 'Monsieur' ?  "assets/icons/man-user-svgrepo-com.svg" : "assets/icons/woman-user-svgrepo-com.svg";
      notifyListeners();
  }

  void plashed() {
    _isSplashed = true;
    notifyListeners();
  }

  void login() {
    _isLogin = true;
    notifyListeners();
  }

  void loginSucess() {
    _logInSucess = true;
    notifyListeners();
  }
  
  void loginFalse() {
    print("oui j'ai mis le login à false");
    _logInSucess = false;

    notifyListeners();
  }

  void modifSucess() {
    print("je ss la aussi");
    _logInSucess = true;
    //_selectedTab = AppTab.home;
    notifyListeners();
  }

  void goToTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void setDisplayProduct(bool val) {
    _displayProduct = val;
    notifyListeners();
  }

  void goToCart() {
    _displayCart = true;
    notifyListeners();
  }

  void setCart(bool val) {
    _displayCart = val;
    notifyListeners();
  }

  void logOut() {
    _isSplashed = false;
    _isLogin = false;
    _logInSucess = false;
    _selectedTab = AppTab.home;
    notifyListeners();
  }

  void setModifyPlofil(val) {
    _displayModifyProfil = val;
    notifyListeners();
  }

  void setCommande(val) {
    _displayCommandes = val;
    notifyListeners();
  }

  void setOnCreatingAccount(val) {
    _onCreatingAccount = val;
    notifyListeners();
  }
}
