import 'package:daily_meme_digest/screen/addmeme.dart';
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
  String username = prefs.getString("username") ?? '';
  return username;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(WelcomeHome());
    else {
      active_user = result;
      print(active_user);
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'home': (context) => Home(username: active_user),
        'myCreation': (context) => MyCreation(username: active_user),
        'addMeme': (context) => AddMeme(username: active_user),
        'leaderboard': (context) => Leaderboard(),
        'setting': (context) => Setting(),
      },
      title: 'Daily Meme Digest',
      theme: ThemeData(
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
    Home(username: active_user),
    MyCreation(username: active_user),
    Leaderboard(),
    Setting()
  ];
  final List<String> _title = ['Home', 'My Creating', 'Leaderboard', 'Setting'];

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
    );
  }

  BottomNavigationBar myBottomNavBar() {
    return BottomNavigationBar(
      fixedColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
          backgroundColor: Colors.blueGrey
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
              otherAccountsPictures: [
                GestureDetector(
                  onTap: () {
                    doLogout();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.logout),
                  ),
                )
              ],
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
        ],
      ),
    );
  }
}
