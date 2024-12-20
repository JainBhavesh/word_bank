import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:insta_login/insta_view.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

// Method for email and password registration

  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error registering with email and password: $e");
      return null;
    }
  }

  // Method for email and password sign-in
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in with email and password: $e");
      return null;
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print("signInWithGoogle==>$credential");
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  // Method for Facebook sign-in
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      // print("result signInWithFacebook---->$result");
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        if (accessToken != null) {
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken.tokenString);
          UserCredential userCredential =
              await _auth.signInWithCredential(facebookAuthCredential);
          return userCredential.user;
        }
      } else {
        print("Facebook sign-in failed: ${result.status}");
        return null;
      }
    } catch (e) {
      print("Error signing in with Facebook: $e");
      return null;
    }
    return null;
  }

  // Method for Instagram sign-in
  Future<User?> signInWithInstagram() async {
    try {
      InstaView(
          instaAppId: '215643524910532',
          instaAppSecret: 'b19d87bf98b632e0319f2ebab495b345',
          redirectUrl: 'https://ayesha-iftikhar.web.app/',
          onComplete: (token, userid, username) {
            print("_token-->$token");
            print("_userid-->$userid");
            print("_username-->$username");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
          });
    } catch (error) {
      print("Error during Instagram login: $error");
    }
    return null;
  }

  // Method for sign-out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
