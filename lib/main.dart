import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  int typedChrctrLenght = 0;
  String lorem =
      "                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus posuere urna magna, non tristique lectus faucibus at. Praesent vestibulum nibh at mauris pellentesque viverra. Vivamus efficitur neque vel dui iaculis, at euismod mauris condimentum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Vestibulum justo mi, imperdiet non erat non, dignissim pulvinar urna. Aliquam blandit metus ac nisl accumsan volutpat. Suspendisse mauris ipsum, mattis quis convallis ut, aliquet eget nisl. Morbi rutrum, elit a porttitor sodales, orci quam ornare urna, sit amet imperdiet elit diam vitae orci. Ut et blandit libero, sit amet ornare nisl. Nunc interdum ex non sodales cursus."
          .toLowerCase()
          .replaceAll(",", "")
          .replaceAll(".", "");
  int step = 0;
  int time = 0;
  String name = "";
  int lastTypeAt = DateTime.now().millisecondsSinceEpoch;

  void updateLastTypeAt() {
    lastTypeAt = DateTime.now().millisecondsSinceEpoch;
  }

  void controlCorrect(String value) {
    String trimmedValue = lorem.trimLeft();
    if (trimmedValue.indexOf(value) != 0) {
      setState(() {
        step++;
      });
    } else {
      typedChrctrLenght = value.length;
    }
  }

  void onType(String value) {
    updateLastTypeAt();
    controlCorrect(value);
  }

  void resetGame() {
    typedChrctrLenght = 0;
    time = 0;
    name = "";
    setState(() {
      step = 0;
    });
  }

  void setName(String value) {
    setState(() {
      if (value.length < 4) {
        name = value.substring(0, 4);
      }
      else if(value.length>8)
        {
          name = value.substring(0, 8);
        }
      else {
        name = value;
      }
    });

  }

  void onStartClick() {
    if (name != "") {
      setState(() {
        step += 1;
        updateLastTypeAt();
      });
      var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (step != 1) {
          timer.cancel();
        }
        if (step == 1 && now - lastTypeAt > 4000) {
          step++;
        }
        setState(() {
          if (step == 1) {
            time++;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;
    if (step == 0) {
      shownWidget = <Widget>[
        Text(
          'Oyuna Hoşgeldin.Hazır mısın?',
          style: TextStyle(fontSize: 26),
        ),Text(
          'İsim Giriniz(Zorunlu)',
          style: TextStyle(fontSize: 15),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: TextField(
            onChanged: setName,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Oyuncu İsmi',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text(
              "Hazırsan Başla!",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: name.length ==0? null : onStartClick,
            color: Colors.orange,
          ),
        ),
      ];
    } else if (step == 1) {
      shownWidget = <Widget>[
        Text(
          'Süre : $time',
          style: TextStyle(fontSize: 30, color: Colors.orange),
        ),
        Text(
          'Score : $typedChrctrLenght',
          style: TextStyle(fontSize: 40, color: Colors.orange),
        ),
        Container(
          margin: EdgeInsets.only(left: 0),
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(
                fontSize: 24, color: Colors.orange, letterSpacing: 2.3),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 100.0,
            pauseAfterRound: Duration(seconds: 20),
            startPadding: 0,
            accelerationDuration: Duration(seconds: 15),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Yazı Yazmaya Başla',
            ),
          ),
        ),
      ];
    } else {
      shownWidget = <Widget>[
        Text(
          'Tebrikler : $name \nOyun Bitti Scorun = $typedChrctrLenght',
          style: TextStyle(fontSize: 26),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text(
              "Yeniden Dene!",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: resetGame,
            color: Colors.orange,
          ),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Hızlı Yazma Yarışı"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
