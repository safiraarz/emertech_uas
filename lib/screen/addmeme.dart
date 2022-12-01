import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class AddMeme extends StatefulWidget {
  final String username;
  AddMeme({Key? key, required this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddMeme();
  }
}

class _AddMeme extends State<AddMeme> {
  late TextEditingController _photo_cont = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String _headerText = "";
  String _footerText = "";
  String active_user = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  
  print(widget.username.toString());
    _photo_cont = TextEditingController();
    _photo_cont.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Meme'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'Preview: ',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 25),
              ),
              Divider(
                height: 10,
              ),
              RepaintBoundary(
                child: Stack(
                  children: <Widget>[
                    Image.network(
                        'https://www.kibrispdr.org/data/799/plain-white-background-51.jpg',
                        fit: BoxFit.fitHeight),
                    if (_photo_cont.text != '') ...[
                      Image.network(_photo_cont.text),
                    ],
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              _headerText.toUpperCase(),
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
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                _footerText.toUpperCase(),
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
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                            maxLength: 150,
                            minLines: 2,
                            maxLines: 4,
                            controller: _photo_cont,
                            decoration: const InputDecoration(
                              labelText: 'Link Image',
                            ),
                            onFieldSubmitted: (v) {
                              setState(() {
                                _photo_cont.text = v.toString();
                              });
                            },
                            //validator masi salahh
                            validator: (value) {
                              if (value == null ||
                                  !Uri.parse(value).isAbsolute) {
                                return 'url image tidak ditemukan';
                              }
                              return null;
                            })),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          maxLength: 20,
                          decoration: const InputDecoration(
                            labelText: 'Header Text',
                          ),
                          onChanged: (value) {
                            _headerText = value;
                          },
                          keyboardType: TextInputType.multiline,
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          maxLength: 20,
                          decoration: const InputDecoration(
                            labelText: 'Footer Text',
                          ),
                          onChanged: (value) {
                            _footerText = value;
                          },
                          keyboardType: TextInputType.multiline,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState != null &&
                              !_formkey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Harap Isian diperbaiki')));
                          } else {
                            submit();
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  //void

  void submit() async {
    print(widget.username.toString());
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419158/meme/newmeme.php"),
        body: {
          'url_memes': _photo_cont.text,
          'text_atas': _headerText,
          'text_bawah': _footerText,
          'username': widget.username.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
}
