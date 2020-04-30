/// Author: Jose G. Perez
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

    /// Event handler for when the Generate quiz button is pressed
    void onGeneratePressed() {
      // Randomize questions
      mQuestionPool.shuffle();
      // Get only the requested number
      List<Question> quizQuestions = mQuestionPool.getRange(0, _numberOfQuestions.toInt()).toList();
      // Put them together into a quiz
      Quiz quiz = Quiz('main_quiz', quizQuestions);
      quiz.resetAnswers();
      // Send them to the quiz navigator
      Navigator.pushNamed(context, 'navigate_quiz', arguments: quiz);
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

  /// Builds the widgets which allow us to select the number of quiz questions
  /// A slider, two buttons (one for +1, one for -1), and a text saying the current number
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

  /// Builds the text widget which displays the current selected number of questions
  Text buildQuestionTextWidget() {
    return Text(_numberOfQuestions.round().toString(),
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple));
  }

  /// Builds the slider widgets which can be used to change the number of questions
  Slider buildSliderWidget(List<Question> mQuestionPool) {
    return Slider(
        value: _numberOfQuestions,
        min: 1,
        max: mQuestionPool.length.toDouble(),
        divisions: mQuestionPool.length,
        onChanged: (newValue) => setState(() => _numberOfQuestions = newValue));
  }

  /// Builds the -1 button widget which can change the number of questions
  RaisedButton buildDownWidget() {
    return RaisedButton(
      child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
      color: Colors.blue,
      onPressed: () => setState(() => _numberOfQuestions--),
    );
  }

  /// Builds the +1 button widget which can change the number of questions
  RaisedButton buildUpWidget() {
    return RaisedButton(
      child: Icon(Icons.keyboard_arrow_up, color: Colors.white),
      color: Colors.blue,
      onPressed: () => setState(() => _numberOfQuestions++),
    );
  }
}
