// Author: Jose G. Perez
import 'package:flutter/material.dart';

class ReviewQuizPage extends StatefulWidget {
  ReviewQuizPage({Key key}) : super(key: key);

  @override
  _ReviewQuizPageState createState() => _ReviewQuizPageState();
}

class _ReviewQuizPageState extends State<ReviewQuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Quiz Page'),
      ),
      body: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [Text('')],
          )),
    );
  }
}
