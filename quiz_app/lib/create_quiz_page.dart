// Author: Jose G. Perez
import 'package:flutter/material.dart';

import 'model/question.dart';
import 'model/quiz.dart';

class CreateQuizPage extends StatefulWidget {
  CreateQuizPage({Key key}) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  double _numberOfQuestions = 1;

  @override
  Widget build(BuildContext context) {
    final List<Question> mQuestionPool = ModalRoute.of(context).settings.arguments;

    void onGeneratePressed(){
      Navigator.pushNamed(context, 'navigate_quiz', arguments: Quiz('main_quiz', mQuestionPool));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Select the number of questions you would like your quiz to have: '),
            buildSelectorWidget(mQuestionPool),
            RaisedButton(
              child: Text('Generate quiz!'),
              onPressed: onGeneratePressed,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSelectorWidget(List<Question> mQuestionPool) {
    return Row(children: [
      Expanded(
          child: Slider(
              value: _numberOfQuestions,
              min: 1,
              max: mQuestionPool.length.toDouble(),
              divisions: mQuestionPool.length,
              onChanged: (newValue) => setState(() => _numberOfQuestions = newValue))),
      Text(_numberOfQuestions.round().toString())
    ]);
  }
}
