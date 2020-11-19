import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async' show Timer;
import 'package:shimmer/shimmer.dart';

void main() {
  runApp( MaterialApp(
    home: LandingPage(),
    theme: ThemeData(
      textTheme: TextTheme(
        headline2: TextStyle(fontSize: 30.0,color:Colors.black54),
        headline3: TextStyle(color:Colors.white),
        headline4: TextStyle(fontSize: 40.0, color: Colors.teal),
        headline5: TextStyle(fontSize: 20.0, color: Colors.white),
        headline6: TextStyle(fontSize: 15.0, color: Colors.teal),
      ),
    ),
  ));
}

bool end = false;

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Shimmer.fromColors(
                highlightColor: Colors.tealAccent,
                baseColor: Colors.teal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Memory Tap', style: Theme.of(context).textTheme.headline4),
                    Image.asset(
                      'assets/images/logo2.png',
                    ),
                    SizedBox(height: 10.0,),
                    Text('The fun is just beginning', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Container(
              child:Stack(
                children: [
                  ButtonGame(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Play', style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Game extends StatefulWidget {
  final int size;

  const Game({Key key, this.size = 12}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List<String> data = [
    'assets/images/foam.png',
    'assets/images/foam.png',
    'assets/images/flower.png',
    'assets/images/flower.png',
    'assets/images/sun.png',
    'assets/images/sun.png',
    'assets/images/maple.png',
    'assets/images/maple.png',
    'assets/images/leaf.png',
    'assets/images/leaf.png',
    'assets/images/ice.png',
    'assets/images/ice.png',
  ];
  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.size; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    startTimer();
    data.shuffle();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (end == false) {
          time = time + 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    "$time",
                    style: Theme.of(context).textTheme.headline3),
              ),

              Theme(
                data: ThemeData.dark(),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) => FlipCard(
                      key: cardStateKeys[index],
                      onFlip: () {
                        if (!flip) {
                          flip = true;
                          previousIndex = index;
                        } else {
                          flip = false;
                          if (previousIndex != index) {
                            if (data[previousIndex] != data[index]) {
                              cardStateKeys[previousIndex]
                                  .currentState
                                  .toggleCard();
                              previousIndex = index;
                            } else {
                              cardFlips[previousIndex] = false;
                              cardFlips[index] = false;
                              print(cardFlips);

                              if (cardFlips.every((t) => t == false)) {
                                end = true;
                                print("Won");
                                showResult();
                              }
                            }
                          }
                        }
                      },
                      direction: FlipDirection.HORIZONTAL,
                      flipOnTouch: cardFlips[index],
                      front: Container(
                        margin: EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/question.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      back: Container(
                        margin: EdgeInsets.all(4.0),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("${data[index]}"),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),
                    ),
                    itemCount: data.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Center(child: Text("You won!", style: Theme.of(context).textTheme.headline4)),
        content: Center(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/congrat.gif'),
                      fit: BoxFit.fill),
                ),
              ),
              Text("Score: $time", style: Theme.of(context).textTheme.headline2)
            ],
          ),
        ),
        actions: <Widget>[
          Column(
            children: [
              Stack(
                children: [
                  ButtonModalGame(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Play again', style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  ButtonModalHome(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Home', style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonGame extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Shimmer.fromColors(
      highlightColor: Colors.tealAccent,
      baseColor: Colors.teal,
      child: Container(
        height: 45,
        margin: EdgeInsets.fromLTRB(55, 0, 55, 0),
        child: ButtonTheme(
          minWidth: double.maxFinite,
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Game(
                    size: 12,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ButtonHome extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Shimmer.fromColors(
      highlightColor: Colors.tealAccent,
      baseColor: Colors.teal,
      child: Container(
        height: 45,
        margin: EdgeInsets.fromLTRB(55, 0, 55, 0),
        child: ButtonTheme(
          minWidth: double.maxFinite,
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LandingPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ButtonModalGame extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Shimmer.fromColors(
      highlightColor: Colors.tealAccent,
      baseColor: Colors.teal,
      child: Container(
        height: 45,
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ButtonTheme(
          minWidth: double.maxFinite,
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Game(
                    size: 12,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ButtonModalHome extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Shimmer.fromColors(
      highlightColor: Colors.tealAccent,
      baseColor: Colors.teal,
      child: Container(
        height: 45,
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ButtonTheme(
          minWidth: double.maxFinite,
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LandingPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}