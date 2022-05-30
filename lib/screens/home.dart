import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
