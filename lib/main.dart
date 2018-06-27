import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Room for status bar
          Container(
            width: double.infinity,
            height: 20.0,
          ),
          //Cards
          Expanded(
            child: CardFlipper(),
          ),
          //Bottom bar
          Container(
            width: double.infinity,
            height: 50.0,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

class CardFlipper extends StatefulWidget {
  @override
  _CardFlipperState createState() => new _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with SingleTickerProviderStateMixin{
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override
  void initState() {
    super.initState();
    finishScrollController = new AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    )
    ..addListener((){
      setState(() {
        scrollPercent = lerpDouble(finishScrollStart,finishScrollEnd,finishScrollController.value);
      });
    });
  }

  @override
  void dispose() {
    finishScrollController.dispose();
    super.dispose();
  }

  Widget _buildCard(int cardIndex, int cardCount, double scrollPercent) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);

    return new FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(),
      ),
    );
  }

  List<Widget> _buildCards() {
    return [
      _buildCard(0, 3, scrollPercent),
      _buildCard(1, 3, scrollPercent),
      _buildCard(2, 3, scrollPercent),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: new Stack(
        children: _buildCards(),
      ),
    );
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singlwCardDragPercent = dragDistance / context.size.width;

    final numCards = 3;
    setState(() {
      scrollPercent =
          (startDragPercentScroll + (-singlwCardDragPercent / numCards))
              .clamp(0.0, 1.0 - (1 / numCards));
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final numCards = 3;
    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent*numCards).round()/numCards;
    finishScrollController.forward(from: 0.0);
    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }
}

class Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //Background
        new ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: new Image.asset(
              'assets/van_on_beach.jpg',
              fit: BoxFit.cover,
            )),
        //Content
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Text(
                '10th street'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'petita',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '2 - 3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 140.0,
                    fontFamily: 'petita',
                    letterSpacing: -5.0,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                  child: Text(
                    'FT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontFamily: 'petita',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '65.10',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'petita',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(30.0),
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: new Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Mostly Cloud',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '11.2mph ENE',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
