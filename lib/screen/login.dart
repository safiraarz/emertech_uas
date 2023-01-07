import 'dart:convert';

import 'package:daily_meme_digest/screen/home.dart';
import 'package:daily_meme_digest/screen/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  late String _username;
  late String _user_password;
  String error_login = "";

  int page = 1;
  PageController controller = PageController(initialPage: 0);

  //LOGIN FUNCTION
  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419158/meme/login.php"),
        body: {'username': _username, 'password': _user_password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("username", json['username']);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login Success')));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => MyApp()));
        main();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login failed. Recheck!')));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => Login()));
      }
    } else {
      throw Exception('Failed to read API');
    }
    main();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //LOGO IMAGE
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/memegenrator.png'),
      ),
    );

    //INPUT EMAIL
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (v) {
        _username = v;
      },
    );

    //INPUT PASSWORD
    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (v) {
        _user_password = v;
      },
    );

    //BUTTON LOGIN
    final loginButton = Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.indigo.shade800,
            borderRadius: BorderRadius.circular(25)),
        child: ElevatedButton(
          onPressed: () {
            doLogin();
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      )
    );

    //BUTTON REGISTER
    final textButtonRegister = TextButton(
      child: Text(
        'Dont have account? Register Now!',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => Register()));
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            textButtonRegister
          ],
        ),
      ),
    );
  }
}
