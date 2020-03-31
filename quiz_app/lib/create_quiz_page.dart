// Author: Jose G. Perez
import 'package:flutter/material.dart';

import 'question.dart';
import 'quiz.dart';

class CreateQuizPage extends StatefulWidget {
  List<Question> mQuestionPool;

  CreateQuizPage({Key key, List<Question> questionPool}) : super(key: key) {
    mQuestionPool = questionPool;
  }

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text('')
          ],
        ),
      ),
    );
  }
}