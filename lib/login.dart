import 'package:app_chat/firebaseHelper.dart';
import 'package:app_chat/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SafeArea(
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 25),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text('Login Page' , style:  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 15),
               child: TextField(
                 controller: emailController,
                 decoration: InputDecoration(
                   hintText: "Enter Your Email",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(20)
                   ) 
                 ),
               ),
             ),
            Padding(
               padding: const EdgeInsets.only(top: 15, bottom: 15),
               child: TextField(
                 controller: passwordController,
                 decoration: InputDecoration(
                   hintText: "Enter Your Password",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(20)
                   ) 
                 ),
               ),
             ),
            ElevatedButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80)
              ),
              onPressed: () async{
                SharedPreferences pref = await SharedPreferences.getInstance();

                  // if email and password is not empty it will take action on it
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      service.loginUser(context, emailController.text,
                          passwordController.text);

                          //it will save user email in email key
                          //from this key we will check if email is present in the key goto chat chatscreen else loginScreen
                          pref.setString("email", emailController.text);
                    } else {
                      // if textfield  are empty it show warning message
                      service.erroBox(context,
                          'Fields must not empty please provide valid email ane password');
                    }

              },
               child: Text('Login')),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage())); 
            }, child: Text("i don't have anyaccount?")),

           ],
         ),
       ),
     ),
    
    );
  }
}
