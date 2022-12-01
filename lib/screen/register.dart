import 'dart:convert';

import 'package:daily_meme_digest/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  late String _username;
  late String _user_password;
  late String _namaDepan;
  late String _namaBelakang;
  late String _linkAvatar;
  bool checkedValue = false;

  int page = 1;
  PageController controller = PageController(initialPage: 0);

  void doRegister() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419158/meme/register.php"),
        body: {
          'username': _username,
          'nama_depan': _namaDepan,
          'nama_belakang': _namaBelakang,
          'password': _user_password,
          'privasi': checkedValue ? '1':'0'
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Username sudah ada')));
        setState(() {
          controller = PageController(initialPage: 0);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Berhasil register')));
      }
    } else {
      throw Exception('Failed to read API');
    }
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
            height: 650,
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
                    height: 65,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 10, right: 25, bottom: 8),
                      child: TextFormField(
                        maxLength: 12,
                        decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          hintText: 'Username',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul harus diisi';
                          }
                          return null;
                        },
                        onChanged: (v) {
                          _username = v;
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 65,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 10, right: 25, bottom: 8),
                      child: TextFormField(
                        maxLength: 12,
                        decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          hintText: 'Nama Depan',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                        ),
                        onChanged: (v) {
                          _namaDepan = v;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul harus diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 65,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 10, right: 25, bottom: 8),
                      child: TextFormField(
                        maxLength: 12,
                        decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          hintText: 'Nama Belakang',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                        ),
                        onChanged: (v) {
                          _namaBelakang = v;
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 65,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 10, right: 25, bottom: 8),
                      child: TextFormField(
                        maxLength: 12,
                        decoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul harus diisi';
                          }
                          return null;
                        },
                        onChanged: (v) {
                          _user_password = v;
                        },
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: Text("Private"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  //button register
                  Container(
                    height: 65,
                    padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.indigo.shade800,
                      onPressed: () {
                        doRegister();
                      },
                      child: Text(
                        'Register',
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
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) => Login()));
                    },
                    child: Text(
                      "Already have account?",
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
