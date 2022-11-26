import 'package:daily_meme_digest/screen/home.dart';
import 'package:daily_meme_digest/screen/leaderboard.dart';
import 'package:daily_meme_digest/screen/login.dart';
import 'package:daily_meme_digest/screen/mycreation.dart';
import 'package:daily_meme_digest/screen/setting.dart';
import 'package:daily_meme_digest/screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(WelcomeHome());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    main();
  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'home': (context) => Home(),
        'myCreation': (context) => MyCreation(),
        'leaderboard': (context) => Leaderboard(),
        'setting': (context) => Setting(),
      },
      title: 'Daily Meme Digest',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Daily Meme Digest'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _screens = [
    Home(),
    MyCreation(),
    Leaderboard(),
    Setting()
  ];
  final List<String> _title = ['home', 'myCreation', 'leaderboard', 'setting'];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      drawer: myDrawer(),
      bottomNavigationBar: myBottomNavBar(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  BottomNavigationBar myBottomNavBar() {
    return BottomNavigationBar(
      // currentIndex: 0,
      fixedColor: Colors.teal,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "My Creation",
          icon: Icon(Icons.emoji_emotions_outlined),
        ),
        BottomNavigationBarItem(
          label: "Leaderboard",
          icon: Icon(Icons.leaderboard),
        ),
        BottomNavigationBarItem(
          label: "Setting",
          icon: Icon(Icons.settings),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(active_user),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
              title: new Text("Home"),
              leading: new Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(context, "home");
              }),
          ListTile(
              title: new Text("My Creation"),
              leading: new Icon(Icons.emoji_emotions_outlined),
              onTap: () {
                Navigator.pushNamed(context, "myCreation");
              }),
          ListTile(
              title: new Text("Leaderboard"),
              leading: new Icon(Icons.leaderboard),
              onTap: () {
                Navigator.pushNamed(context, "leaderboard");
              }),
          ListTile(
              title: new Text("Setting"),
              leading: new Icon(Icons.settings),
              onTap: () {
                Navigator.pushNamed(context, "setting");
              }),
          ListTile(
              title: Text("Log Out"),
              leading: Icon(Icons.logout),
              onTap: () {
                doLogout();
              }),
        ],
      ),
    );
  }
}
