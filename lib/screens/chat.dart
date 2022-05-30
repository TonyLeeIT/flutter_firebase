import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helper/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final auth = FirebaseAuth.instance;
  TextEditingController msg = TextEditingController();
  final storeMsg = FirebaseFirestore.instance;

  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  FirebaseHelper firebaseHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                firebaseHelper.signOut(context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(loginUser!.email.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Container(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              reverse: true,
              child: _showMessage(context),
            ),
          )),
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.blue, width: 0.4))),
                child: TextField(
                  controller: msg,
                  decoration: InputDecoration(hintText: "Enter Message..."),
                ),
              )),
              IconButton(
                  onPressed: () {
                    if (msg.text.isNotEmpty) {
                      storeMsg.collection("Messages").doc().set({
                        "message": msg.text.trim(),
                        "user": loginUser!.email.toString(),
                        "time": DateTime.now()
                      });
                      msg.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _showMessage(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .orderBy("time")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    itemBuilder: (context, i) {
                      QueryDocumentSnapshot x = snapshot.data!.docs[i];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: loginUser!.email == x["user"]
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: loginUser!.email == x["user"]
                                      ? Colors.blue
                                      : Colors.deepOrangeAccent),
                              child: Text(
                                x["message"],
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
          );
        });
  }
}
