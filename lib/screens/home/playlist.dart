import 'package:audioplayers/audioplayers.dart';
import 'package:first_firebase_project/screens/home/components.dart';
import 'package:first_firebase_project/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class MusicApp extends StatefulWidget {
  // const MusicApp({Key? key}) : super(key: key);
  final List musicList;
  const MusicApp(this.musicList);
  @override
  _MusicAppState createState() => _MusicAppState();
}
class _MusicAppState extends State<MusicApp> {
  // List musicList = [];
  //
  // _MusicAppState() {
  //
  //   FirebaseDatabase.instance.reference().child("${getCurrentUID()}").once().then((dataSnapshot){
  //     print("Sucessfully loaded the data");
  //     dataSnapshot.value.forEach((k,v){
  //       musicList.add(v);
  //     });
  //     setState(() {
  //
  //     });
  //   }).catchError((error) {
  //     print("Failed to loaded the data");
  //   });
  // }

  bool isSelected = true;
  String _currentTitle = "";
  String _currentSinger = "";
  String _currentCover = "";
  IconData btnIcon = Icons.pause;
  IconData btnFast = Icons.fast_forward;
  IconData btnSlow = Icons.fast_rewind;


  // The MP3 Player
  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String _currentSong = "";

  // Bar move
  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async {
    if(isPlaying && _currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if(result == 1) {
        setState(() {
          _currentSong = url;
        });
      }
    } else if(!isPlaying) {
      int result = await audioPlayer.play(url);
      if(result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }
  @override
  Widget build(BuildContext context) {
    void _showSettingPanel() {
      showMaterialModalBottomSheet(
          duration: Duration(milliseconds: 1000),
          barrierColor: Colors.pink[100],
          expand: false,
          context: context,
          // isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context){
            return SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: SettingForms(),
              ),
            );
          });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: widget.musicList.length,
                itemBuilder: (context, index) => customListTitle(
                  onTap: () {
                    playMusic(widget.musicList[index]['url']);
                    setState(() {
                      _currentTitle = widget.musicList[index]['title'];
                      _currentSinger = widget.musicList[index]['singer'];
                      _currentCover = widget.musicList[index]['cover'];
                    });
                  },
                  title: widget.musicList[index]['title'],
                  singer: widget.musicList[index]['singer'],
                  cover: widget.musicList[index]['cover'],
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 20.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.pink[300],
                      child: Icon(Icons.add),
                      onPressed: (){
                        _showSettingPanel();
                      },
                    ),
                  ),
                  Slider.adaptive(
                      activeColor: Colors.pink[300],
                      inactiveColor: Colors.grey[200],
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          seekToSecond(value.toInt());
                          value = value;
                        });
                      }
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: NetworkImage(_currentCover),
                              )
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              _currentTitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              _currentSinger,
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16.0
                              ),
                            )
                          ],
                        ),
                        IconButton(
                            icon: Icon(btnSlow),
                            color: Colors.grey[400],
                            onPressed: (){
                              if(isSelected) {
                                audioPlayer.setPlaybackRate(playbackRate: 0.5);
                                setState(() {
                                  isSelected = false;
                                  btnSlow = Icons.fast_rewind_outlined;
                                });
                              }
                              else {
                                audioPlayer.setPlaybackRate(playbackRate: 1.0);
                                setState(() {
                                  isSelected = true;
                                  btnSlow = Icons.fast_rewind;
                                });
                              }
                            },
                        ),
                        IconButton(
                          color: Colors.grey[400],
                          iconSize: 40.0,
                          icon: Icon(btnIcon),
                          onPressed: (){
                            if(isPlaying) {
                              audioPlayer.pause();
                              setState(() {
                                btnIcon = Icons.play_arrow;
                                isPlaying = false;
                              });
                            } else {
                              audioPlayer.resume();
                              setState(() {
                                btnIcon = Icons.pause;
                                isPlaying = true;
                              });
                            }
                          },
                        ),
                        IconButton(
                          color: Colors.grey[400],
                          onPressed: (){
                            if(isSelected) {
                              audioPlayer.setPlaybackRate(playbackRate: 1.5);
                              setState(() {
                                isSelected = false;
                                btnFast = Icons.fast_forward_outlined;
                              });
                            }
                            else {
                              audioPlayer.setPlaybackRate(playbackRate: 1.0);
                              setState(() {
                                isSelected = true;
                                btnFast = Icons.fast_forward;
                              });
                            }
                          },
                          icon: Icon(btnFast),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
