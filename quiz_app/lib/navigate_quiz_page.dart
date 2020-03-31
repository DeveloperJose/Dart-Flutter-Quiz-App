// Author: Jose G. Perez
import 'package:flutter/material.dart';

import 'model/quiz.dart';

class NavigateQuizPage extends StatefulWidget {
  NavigateQuizPage({Key key}) : super(key: key);

  @override
  _NavigateQuizPageState createState() => _NavigateQuizPageState();
}

class _NavigateQuizPageState extends State<NavigateQuizPage> {
  int currentQuestionIDX = 0;

  @override
  Widget build(BuildContext context) {
    final Quiz mQuiz = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Navigate Quiz Page'),
      ),
      body: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text('Question Stem: ${mQuiz.questions[currentQuestionIDX].stem}'),
              buildNavigationWidget(mQuiz),
            ],
          )),
    );
  }

  Widget buildNavigationWidget(Quiz quiz) {
    return Row(
      children: [buildPreviousButton(), buildNextButton(quiz)],
    );
  }

  Widget buildPreviousButton() {
    bool isEnabled = (currentQuestionIDX != 0);
    void onPress() => setState(() => currentQuestionIDX--);
    return RaisedButton(
      child: Text('Previous Question'),
      onPressed: isEnabled ? onPress : null,
    );
  }

  Widget buildNextButton(Quiz quiz) {
    bool isEnabled = (currentQuestionIDX < quiz.questions.length);
    void onPress() => setState(() => currentQuestionIDX++);
    return RaisedButton(
      child: Text('Next Question'),
      onPressed: isEnabled ? onPress : null,
    );
  }
}
