import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoboshu TAsk',
      home: const MyHomePage(title: 'Mindful Meal Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  int _start = 30;
  String audioasset = "countdown.mp3";
  int state = 0;
  AudioPlayer player = AudioPlayer();
  bool _radio = true;
  List<String> heading = ["Nom Nom :)", "Break Time", "Finish Your Meal"];
  List<String> subtext = [
    "It's simple: eat slowly for ten minutes,rest for five then finish your meal!",
    "Take a five minute break and then check your fullness!",
    "You can eat until you feel full",
  ];
  void pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {});
    }
  }

  void unpauseTimer() => startTimer(_start);

  void startTimer(int startVal) async {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      if (startVal == 0) {
        _start = 30;
        if (state == 2) {
          state = 0;
        } else {
          state++;
        }
      } else {
        _start = startVal;
      }
    });
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
            if (_start <= 5) {
              player.play(AssetSource(audioasset));
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 22, 32),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 24, 22, 32),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * 0.01),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: MediaQuery.of(context).size.width * 0.05,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state == 0
                            ? Colors.white
                            : Colors.white.withOpacity(0.2)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: MediaQuery.of(context).size.width * 0.05,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.015),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state == 1
                            ? Colors.white
                            : Colors.white.withOpacity(0.2)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: MediaQuery.of(context).size.width * 0.05,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state == 2
                            ? Colors.white
                            : Colors.white.withOpacity(0.2)),
                  ),
                ],
              ),
            ),
            Text(
              heading[state],
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              subtext[state],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 177, 175, 175), fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.width * 0.50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.45,
                    child: CircularProgressIndicator(
                      value: _start / 30,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '00:${_start < 10 ? "0" + _start.toString() : _start.toString()}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      const Text(
                        'minute\'s remaining',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              child: CupertinoSwitch(
                  value: _radio,
                  onChanged: (val) {
                    setState(() {
                      _radio = val;
                      if (_radio == false) {
                        player.setVolume(0);
                      } else {
                        player.setVolume(1);
                      }
                    });
                  }),
            ),
            Text(
              _radio == false ? "Sound off" : "Sound on",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  top: MediaQuery.of(context).size.height * 0.03),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _start == 30 || _start == 0
                      ? unpauseTimer()
                      : _timer!.isActive
                          ? pauseTimer()
                          : unpauseTimer();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _start == 30 || _start == 0
                        ? "START"
                        : _timer!.isActive
                            ? "PAUSE"
                            : "RESUME",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'LET\'S STOP I\'M FULL NOW!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
