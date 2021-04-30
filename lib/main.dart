import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double temperature = 0;

  Future<double> getData() async {
    var queryParams = {
      'q': 'London',
      'units': 'metric',
      'appid': '7334ab1bd042a260dbc699d2b8e8a42d'
    };
    http.Response respons = await http.get(
        Uri.https('api.openweathermap.org', 'data/2.5/weather', queryParams));

    var jsonData = jsonDecode(respons.body);
    double temp = jsonData['main']['temp'];
    setState(() {
      temperature = temp;
    });
  }

  List<TileItem> itemss = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        _buildTopBar(context),
        _buildBodyContent(),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: RaisedButton(
            child: Text(
              'Add items',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            color: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              _awaitReturnValueFromSecondScreen(context);
            },
          ),
        )
      ]),
    );
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(),
        ));

    setState(() {
      if (result != '') {
        itemss.add(TileItem(
          isChecked: true,
          title: result,
          image: 'assets/avatar_holder.png',
        ));
      }
    });
  }

  Stack _buildTopBar(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity, // MediaQuery.of(context).size.width
          height: 140,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/BackUp.jpg'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 40),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText('TODOa'),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 20,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text('temperature London - $temperature',
                style: TextStyle(color: Colors.red, fontSize: 20)),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 20.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
            ),
          ),
        ),
      ],
    );
  }

  Expanded _buildBodyContent() {
    return Expanded(
      child: ListView(
        children: itemss,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  @override
  Future<void> initState() {
    itemss = items(2);
    getData();
  }

  List<TileItem> items(int countItem) {
    List<TileItem> itemss = [];
    for (int i = 0; i < countItem; i++) {
      if (i % 3 == 0) {
        itemss.add(TileItem(
          isChecked: true,
          title: 'Item Text $i',
          image: null,
        ));
      } else if (i % 2 == 0) {
        itemss.add(TileItem(
          isChecked: false,
          title: 'Item Text $i',
          image: 'assets/avatar_holder.png',
        ));
      } else {
        itemss.add(TileItem(
          isChecked: true,
          title: 'Item Text $i',
          image: 'assets/avatar_holder.png',
        ));
      }
    }
    return itemss;
  }
}

class TileItem extends StatefulWidget {
  bool isChecked;
  final String image;
  final String title;

  TileItem({
    this.isChecked = false,
    this.title,
    this.image,
  });
  @override
  _TileItemState createState() => _TileItemState();
}

class _TileItemState extends State<TileItem> {
  @override
  Widget build(BuildContext context) {
    bool isImageExists = !(widget.image == null || widget.image.isEmpty);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
      child: Row(
        children: [
          Checkbox(
            value: widget.isChecked,
            onChanged: (bool value) {
              setState(() {
                widget.isChecked = value;
              });
            },
          ),
          Container(
            margin: EdgeInsets.all(12.0),
            width: isImageExists ? 60.0 : 10.0,
            height: 60.0,
            decoration: isImageExists
                ? BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      image: AssetImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 4.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  )
                : null,
          ),
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 24),
            ),
          )
        ],
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() {
    return _SecondScreenState();
  }
}

class _SecondScreenState extends State<SecondScreen> {
  // this allows us to access the TextField text
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Add items'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Colors.blue,
            onPressed: () {
              _sendDataBack(context);
            },
          )
        ],
      ),
    );
  }

  // get the text in the TextField and send it back to the FirstScreen
  void _sendDataBack(BuildContext context) {
    String textToSendBack = textFieldController.text;
    Navigator.pop(context, textToSendBack);
  }
}
