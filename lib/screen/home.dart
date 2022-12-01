import 'dart:convert';
import 'package:daily_meme_digest/class/memes.dart';
import 'package:daily_meme_digest/screen/addmeme.dart';
import 'package:daily_meme_digest/screen/memedetail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

class Home extends StatefulWidget {
  final String username;
  Home({Key? key, required this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Memes? _mm;
  @override
  void initState() {
    super.initState();
    checkUser().then((String result) {
      setState(() {
        active_user = result;
      });
    });
    Meme.clear();
    bacaData();
  }

  Future<String> fetchData() async {
    checkUser().then((String result) {
      setState(() {
        active_user = result;
      });
    });
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419158/meme/allmemes.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Meme.clear();
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json);
      for (var m in json['data']) {
        Memes mm = Memes.fromJson(m);
        Meme.add(mm);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Meme Digest')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AddMeme(username: widget.username.toString())));
        },
        child: const Icon(Icons.add),
      ),
      body: _buildPost(Meme),
    );
  }

  Widget _buildPost(Memes_) {
    return ListView.builder(
      itemCount: Memes_.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image(
                                height: 50.0,
                                width: 50.0,
                                image: NetworkImage(Memes_[index].url_memes),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          Memes_[index].username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_horiz),
                          color: Colors.black,
                          onPressed: () => print('More'),
                        ),
                      ),
                      InkWell(
                          onDoubleTap: () => print('Like post'),
                          onTap: () {},
                          child: RepaintBoundary(
                            child: Stack(
                              children: <Widget>[
                                Image.network(Memes_[index].url_memes),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 220,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          Memes_[index].teks_atas.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 26,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(2.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Colors.black87,
                                              ),
                                              Shadow(
                                                offset: Offset(2.0, 2.0),
                                                blurRadius: 8.0,
                                                color: Colors.black87,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            Memes_[index]
                                                .teks_bawah
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 26,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black87,
                                                ),
                                                Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 8.0,
                                                  color: Colors.black87,
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      iconSize: 30.0,color: Colors.red,
                                      onPressed: () => print(''),
                                      //ini harus di coding biar like +1 di DB
                                    ),
                                    Text(
                                      Memes_[index].jumlah_like.toString(),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.chat),
                                      iconSize: 30.0,
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (_) => MemeDetail(
                                        //       post: posts[index],
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
