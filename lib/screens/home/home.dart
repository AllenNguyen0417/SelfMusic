import 'package:first_firebase_project/screens/home/playlist.dart';
import 'package:first_firebase_project/services/auth.dart';
import 'package:flutter/material.dart';
import '../wrapper.dart';
import 'package:dio/dio.dart';
import 'package:first_firebase_project/services/database.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool loading = false;

  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List musicList = [];
  List filteredMusicList = [];
  Widget _appBarTitle = new Text('Music List');
  Icon _searchIcon = new Icon(Icons.search);
  _HomeState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredMusicList = musicList;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getMusics();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: _appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
            FlatButton(
                minWidth: 20.0,
                onPressed: () async {
                  loading = true;
                  await _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Wrapper()), (
                      route) => false
                  );
                },
                child: Icon(Icons.logout, color: Colors.white,)
            ),]
      ),
      body: Container(
        child: _buildList(),
      ),
      // resizeToAvoidBottomInset: false,
    );
  }
  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = [];
      for (int i = 0; i < filteredMusicList.length; i++) {
        if (filteredMusicList[i]['title'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredMusicList[i]);
        }
      }
      filteredMusicList = tempList;
    }
    return MusicApp(filteredMusicList);
  }
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white,),
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Music List');
        filteredMusicList = musicList;
        _filter.clear();
      }
    });
  }
  void _getMusics() async {
    FirebaseDatabase.instance.reference().child("${getCurrentUID()}").once().then((dataSnapshot) {
      print("Successfully loaded the data");
      dataSnapshot.value.forEach((k, v) {
        musicList.add(v);
      });
      setState(() {
      });
    }).catchError((error) {
      print("Failed to loaded the data");
    });
    setState(() {
      musicList.shuffle();
      filteredMusicList = musicList;
    });
  }
}


