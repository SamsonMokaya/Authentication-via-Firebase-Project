// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:testingfb/myButton.dart';
import 'package:testingfb/square_tile.dart';

class LoginPage extends StatefulWidget {

  final Function()? onTap;
  

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  void showErrorMessage(String message){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Center(
              child: Text(
                message,
              ),
            ),
          );
        }
    );
  }


  //sign in user
  void signUserIn() async{
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("All fields are required"),
            );
          }
      );
      return;
    }

    //show dialog circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);

    }on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      showErrorMessage(error.code);
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: SafeArea(child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Icon(
                Icons.android,
                size: 100,
              ),


              Text("Hello!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  )
              ),

              Text("Welcome Back",
                style: TextStyle(
                    fontSize: 20
                ),
              ),

              SizedBox(height: 40,),

              //email text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    )
                ),
              ),

              SizedBox(height: 10,),

              //password text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                      ),
                    )
                ),
              ),

              //sign in button
              myButton(
                onTap: signUserIn,
                text: "Sign In"
              ),

              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Register here",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // or sign in with google or github
              const SizedBox(height: 15,),

                  Text("Or sign in with",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),

              const SizedBox(height: 30,),


              //google or twitter
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    imagePath: 'assets/google.png',
                    onTap: () {},
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
      ),
    );
  }
}