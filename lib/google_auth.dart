import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_notes/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

CollectionReference users = FirebaseFirestore.instance.collection('users');
Future<bool> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    // ignore: unnecessary_null_comparison
    if (GoogleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);

      final User? user = authResult.user;

      final userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'photoURL': googleSignInAccount.photoUrl,
        'email': googleSignInAccount.email,
      };

      users.doc(user!.uid).get().then((doc) {
        if (doc.exists) {
          //old user
          doc.reference.update(userData);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // new user
          users.doc(user.uid).set(userData);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  } catch (e) {
    print(e);
    print('Signin unsuccessful !');
  }
  return true;
}
