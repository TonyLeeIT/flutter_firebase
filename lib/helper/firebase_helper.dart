import 'package:firebase/screens/chat.dart';
import 'package:firebase/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseHelper {
  final auth = FirebaseAuth.instance;

  void createUser(context, email, password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {Get.to(() => Chat())});
    } catch (e) {
      errorBox(context, e);
    }
  }

  void loginUser(context, email, password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {Get.to(() => Chat())});
    } catch (e) {
      errorBox(context, e);
    }
  }

  void signOut(context) async {
    try {
      await auth.signOut().then((value) => Get.to(() => Login()));
    } catch (e) {
      errorBox(context, e);
    }
  }

  void errorBox(context, e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
          );
        });
  }
}
