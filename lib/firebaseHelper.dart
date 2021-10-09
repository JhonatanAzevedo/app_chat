import 'package:app_chat/chatScreen.dart';
import 'package:app_chat/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Service {
  //in service class we done all firebase auth
  final auth = FirebaseAuth.instance;
  // for creat User we define function
  //it take 3 parameters context, email, password
  void createUser(context, email, password) async {
    try {
      //when the creat it will go to chatScreen directly not to login page
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()))
              });
    } catch (e) {
      // if it has error then it will show dialogue
      erroBox(context, e);
    }
  }

  //for login we define loginUser function
  void loginUser(context, email, password) async {
    try {
       await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()))
              });

    } catch (e) {
      // if it has error then it will show dialogue
      erroBox(context, e);
    }
  }

  //for sinout
  void signOut(context, ) async {
    try {
    // this function helps to siginOut user
    await auth.signOut().then((value) => {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),
       (route) => false)
    });
    } catch (e) {
      // if it has error then it will show dialogue
      erroBox(context, e);
    }
  }

  //for display error we define errorBox function
  void erroBox(context, e) {
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
