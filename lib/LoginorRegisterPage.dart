import 'package:flutter/material.dart';
import 'package:testingfb/login_page.dart';

import 'RegisterPage.dart';

class LoginorRegisterPage extends StatefulWidget {
  const LoginorRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginorRegisterPage> createState() => _LoginorRegisterPageState();
}

class _LoginorRegisterPageState extends State<LoginorRegisterPage> {

  bool showLogInpage = true;

  void togglepages(){
    setState(() {
      showLogInpage = !showLogInpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLogInpage){
      return LoginPage(onTap: togglepages,);
    }else{
      return RegisterPage(onTap: togglepages,);
    }
  }
}

