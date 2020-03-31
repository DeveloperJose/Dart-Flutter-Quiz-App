// Author: Jose G. Perez
import 'package:flutter/material.dart';
import 'package:quizapp/model/question.dart';

import 'model/quiz.dart';
import 'widgets.dart';

class NavigateQuizPage extends StatefulWidget {
  NavigateQuizPage({Key key}) : super(key: key);

  @override
  _NavigateQuizPageState createState() => _NavigateQuizPageState();
}

class _NavigateQuizPageState extends State<NavigateQuizPage> {
  int currentQuestionIDX = 0;
  GlobalKey<QuestionState> _questionKey = GlobalKey();

  bool validateAndUpdate(Quiz mQuiz, int newIndex) {
    bool isValid = _questionKey.currentState.validate();
    if (isValid) {
      _questionKey.currentState.save();
      setState(() => currentQuestionIDX = newIndex);
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final Quiz mQuiz = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Navigate Quiz Page'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              QuestionWidget(key: _questionKey, mQuestion: mQuiz.questions[currentQuestionIDX]),
              buildNavigationWidget(mQuiz),
            ],
          )),
    );
  }

  Widget buildNavigationWidget(Quiz mQuiz) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [buildPreviousButton(mQuiz), buildNextButton(mQuiz)],
    );
  }

  Widget buildPreviousButton(Quiz mQuiz) {
    bool isEnabled = (currentQuestionIDX != 0);
    void onPress() => validateAndUpdate(mQuiz, currentQuestionIDX - 1);
    return RaisedButton(
      child: Text('Previous Question'),
      onPressed: isEnabled ? onPress : null,
    );
  }

  Widget buildNextButton(Quiz mQuiz) {
    bool isEnabled = (currentQuestionIDX < mQuiz.questions.length);
    void onPress() => validateAndUpdate(mQuiz, currentQuestionIDX + 1);
    return RaisedButton(
      child: Text('Next Question'),
      onPressed: isEnabled ? onPress : null,
    );
  }
}
