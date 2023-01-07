import 'dart:convert';
import 'package:daily_meme_digest/class/example_user.dart';
import 'package:daily_meme_digest/main.dart';

import 'package:flutter/material.dart';
import 'package:daily_meme_digest/widget/profile_widget.dart';
import 'package:daily_meme_digest/class/user.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Setting();
  }
}

  late String _namaDepan;
  late String _namaBelakang;

class _Setting extends State<Setting> {
  List<User> _user = [];
  bool valuecheckbox = false; //nanti diambil dari database isChecked

  @override
  initState() {
    bacaData();
  }



  bacaData() {
  Future<String> data = fetchData();
      data.then((value) {
        Map json = jsonDecode(value);

        var data = json['data'];
        print(data);
        // _namaDepan = json['data']['nama_depan'];
        // _namaBelakang = json['data']['nama_belakang'];
      });
  }

  Future<String> fetchData() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';

  final response = await http.post(
    Uri.parse("https://ubaya.fun/flutter/160419158/meme/get_user.php"),
    body:{
      "value":"get profile",
      "username":username
    });
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to read API');
  }
}

  void updateProfile()async{
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? '';
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419158/meme/updateProfile.php"),
        body: {
          'nama_depan': _namaDepan,
          'nama_belakang': _namaBelakang,
          'username':username
        });
        debugPrint(response.body);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal Update Profile')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Berhasil Update Profile')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _users = UserPreferences.myUser;

    String _temp = 'waiting API respond…';

    var exampleImage;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  doLogout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // ProfileWidget(
            //   imagePath: _users.imagePath,
            //   onClicked: () async {},
            // ),
            const SizedBox(height: 24),
            buildName(_users),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Text("First Name",
                  style: TextStyle(
                    fontSize: 19,
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name'),
                    onChanged: (v) {
                      _namaDepan = v;
                    }
              ),           
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Text("Last Name",
                  style: TextStyle(
                    fontSize: 19,
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name'),
                    onChanged: (v) {
                      _namaBelakang = v;
                    }
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.blueGrey,
                      value: valuecheckbox,
                      onChanged: (bool? value) {
                        setState(() {
                          valuecheckbox = value!;
                        });
                      },
                    ),
                    Text(
                      'Hide My Name',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ],
                )
              ]),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade800,
                      borderRadius: BorderRadius.circular(25)),
                  child: ElevatedButton(
                    onPressed: () {
                       updateProfile();
                    },
                    child: Text(
                      'Save Change',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ],
        ));
  }
}

Widget buildName(User user) => Column(
      children: [
        Text(
          user.firstName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.userName,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );




void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("username");
  main();
}

