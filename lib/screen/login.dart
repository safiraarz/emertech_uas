import 'dart:convert';

import 'package:daily_meme_digest/screen/home.dart';
import 'package:daily_meme_digest/screen/register.dart';
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
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fill,
          image: NetworkImage(
            'https://learn.canva.com/wp-content/uploads/2015/11/desktop-wallpaper.jpg',
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 55,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 10, right: 25, bottom: 8),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          hintText: 'Username',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                        ),
                        onChanged: (v) {
                          _username = v;
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 10, right: 25, bottom: 8),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                        ),
                        onChanged: (v) {
                          _user_password = v;
                        },
                      ),
                    ),
                  ),
                  //button login
                  Container(
                    height: 55,
                    padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.indigo.shade800,
                      onPressed: () {
                        doLogin();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => Register()));
                    },
                    child: Text(
                      "Don't have account?",
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Divider(thickness: 0, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
