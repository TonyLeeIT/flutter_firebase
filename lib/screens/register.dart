import 'package:firebase/helper/firebase_helper.dart';
import 'package:firebase/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  FirebaseHelper firebaseHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register Page",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      label: Icon(Icons.mail),
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(
                      label: Icon(Icons.password),
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 80)),
                  onPressed: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    var _email = emailController.text;
                    var _pass = passController.text;
                    if (_email.isNotEmpty &&
                        _pass.isNotEmpty) {
                      firebaseHelper.createUser(context, _email, _pass);
                      pref.setString("email", _email);
                    } else {
                      firebaseHelper.errorBox(context,
                          "Fields must not empty , please provide valid email and password");
                    }
                  },
                  child: Text("Register")),
              TextButton(
                  onPressed: () {
                    Get.to(() => Login());
                  },
                  child: Text("Already have account"))
            ],
          ),
        ),
      ),
    );
  }
}
