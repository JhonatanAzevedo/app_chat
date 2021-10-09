import 'package:app_chat/firebaseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();

  final storeMenssege = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController msg = TextEditingController();

  getCurrentUser() {
    final user = auth.currentUser;
    //if user not empty  it assingn to login user
    if (user != null) {
      loginUser = user;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                service.signOut(context);
                //now here we remove that email from the key user click logOut button

                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
                // it will remove user  email when user click logOut button
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(loginUser!.email.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //display messages
          Expanded(child: ShowMesseges()),

          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.blue, width: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: msg,
                    decoration: InputDecoration(hintText: "Enter Message..."),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (msg.text.isNotEmpty) {
                    storeMenssege.collection("Messages").doc().set({
                      "messages": msg.text.trim(),
                      "user": loginUser!.email.toString(),
                      "time": DateTime.now()
                    });

                    msg.clear();
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.teal,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ShowMesseges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //now we can oderd the messages that sent message show in the bottom
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Messages")
          .orderBy("time")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data!.docs[i];
              return ListTile(
                title: Column(
                  //if user is as self then text show in the end
                  //else other user chat show in start
                  crossAxisAlignment: loginUser!.email == x['user']
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      //if user as self it show blue color else amber color
                      decoration: BoxDecoration(
                        color: loginUser!.email == x['user']
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.amber.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(x['messages']),
                          SizedBox(height: 5),
                          Text(
                            "user: " + x['user'],
                            style: TextStyle(fontSize: 13, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
