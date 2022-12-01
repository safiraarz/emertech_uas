import 'package:flutter/material.dart';

class MemeDetail extends StatefulWidget {
  // final int id;
  // String username;
  // MemeDetail({Key? key, required this.id, required this.username})
  //     : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MemeDetailState();
  }
}

class _MemeDetailState extends State<MemeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail of Recipe'),
        ),
        body: ListView(children: <Widget>[

        ]));
  }
}
