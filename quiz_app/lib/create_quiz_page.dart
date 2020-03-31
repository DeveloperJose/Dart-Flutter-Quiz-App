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
  double _numberOfQuestions = 2;

  @override
  Widget build(BuildContext context) {
    final List<Question> mQuestionPool = ModalRoute.of(context).settings.arguments;

    void onGeneratePressed() {
      mQuestionPool.shuffle();
      List<Question> quizQuestions = mQuestionPool.getRange(0, _numberOfQuestions.toInt()).toList();
      Navigator.pushNamed(context, 'navigate_quiz', arguments: Quiz('main_quiz', quizQuestions));
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
    return Column(children: [
      Row(children: [
        Expanded(child: buildSliderWidget(mQuestionPool)),
        buildQuestionTextWidget(),
      ]),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDownWidget(),
            SizedBox(
              width: 30,
              height: 0,
            ),
            buildUpWidget()
          ],
        ),
      )
    ]);
  }

  Text buildQuestionTextWidget() {
    return Text(_numberOfQuestions.round().toString(),
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple));
  }

  Slider buildSliderWidget(List<Question> mQuestionPool) {
    return Slider(
        value: _numberOfQuestions,
        min: 2,
        max: mQuestionPool.length.toDouble(),
        divisions: mQuestionPool.length,
        onChanged: (newValue) => setState(() => _numberOfQuestions = newValue));
  }

  RaisedButton buildDownWidget() {
    return RaisedButton(
      child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
      color: Colors.blue,
      onPressed: () => setState(() => _numberOfQuestions--),
    );
  }

  RaisedButton buildUpWidget() {
    return RaisedButton(
      child: Icon(Icons.keyboard_arrow_up, color: Colors.white),
      color: Colors.blue,
      onPressed: () => setState(() => _numberOfQuestions++),
    );
  }
}
