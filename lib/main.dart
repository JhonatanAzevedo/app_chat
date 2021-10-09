import 'package:app_chat/chatScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

void main() async {

  // now in main we will check if user email is present in the key
  // the go to ChatScreen else login Screen
  //here in the app when we restart the it will goto to login page lets see
  // for this we will take email from key the email is remove from key when the user click logOut Button else is
  //it preset all the time



  // initialize firebase
  //also ass multi Dex in the gradle
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    SharedPreferences pref = await SharedPreferences.getInstance();

  // getting  email from email key
  var email = pref.getString("email");


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //when email is null it got login else chatScren
    //now if we restart it will goto to login page because the email is currntly not saved it will save when
    ///we register to account or login to account
    //lets see
    //the email is currently  empty so that why error come
    //its occure  due to null safety 
    // now if we restart or close  our app then again open app it directly goto  chat screen
    // if we logOut then restart it goto  login page
    home: email == null? LoginPage() : ChatScreen(),
  ));
}


