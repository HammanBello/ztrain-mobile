import 'package:shop_app/helper/response.dart';

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<Response> signInWithEmailAndPassword(String email, String password);
  Future<Response> createUserWithEmailAndPassord(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<Response> signInWithGoogle();
  Future<Response> signInWithFacebook();
  Future<String> signInWithTweeter();
}
