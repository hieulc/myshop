import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  String? _accessToken;
  String? _idToken;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    print(googleUser);
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    _accessToken = googleAuth.accessToken;
    _idToken = googleAuth.idToken;
    print('ACCESS_TOKEN: $_accessToken');
    print('ID_TOKEN: $_idToken');
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(credential);
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

}