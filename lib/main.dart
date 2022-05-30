import 'package:firebase/screens/chat.dart';
import 'package:firebase/screens/home.dart';
import 'package:firebase/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString("email");
  runApp(MyApp(
    account: email.toString(),
  ));
}

class MyApp extends StatelessWidget {
  final String account;

  MyApp({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chat app with Firebase",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: this.account == null ? Login() : Chat());
  }
}
