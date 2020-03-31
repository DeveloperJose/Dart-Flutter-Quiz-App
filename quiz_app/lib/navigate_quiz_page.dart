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
      _questionKey.currentState.updateQuestion(mQuiz.questions[newIndex]);
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
            children: [buildQuestionWidget(mQuiz), buildNavigationWidget(mQuiz), buildProgress(mQuiz)],
          )),
    );
  }

  Widget buildQuestionWidget(Quiz mQuiz) {
    Question currentQuestion = mQuiz.questions[currentQuestionIDX];
    if (currentQuestion is MultipleChoice)
      return MultipleChoiceWidget(key: _questionKey, mQuestion: currentQuestion);
    else
      return FillInTheBlankWidget(key: _questionKey, mQuestion: currentQuestion);
  }

  Widget buildNavigationWidget(Quiz mQuiz) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [buildPreviousButton(mQuiz), buildNextButton(mQuiz)],
    );
  }

  Widget buildPreviousButton(Quiz mQuiz) {
    bool isEnabled = (currentQuestionIDX > 0);
    void onPress() => validateAndUpdate(mQuiz, currentQuestionIDX - 1);
    return RaisedButton(
      child: Text('Previous Question'),
      onPressed: isEnabled ? onPress : null,
    );
  }

  Widget buildNextButton(Quiz mQuiz) {
    bool isLast = (currentQuestionIDX < mQuiz.questions.length - 1);
    void onPress() {
      if (isLast) {
        // Go to grading screen
      } else {
        validateAndUpdate(mQuiz, currentQuestionIDX + 1);
      }
    }

    return RaisedButton(
      child: Text(isLast ? 'Submit and Grade' : 'Next Question'),
      onPressed: onPress,
    );
  }

  Widget buildProgress(Quiz mQuiz) {
    double value = (currentQuestionIDX + 1) / mQuiz.questions.length;
    return Column(children: [
      LinearProgressIndicator(value: value),
      Text('Question ${currentQuestionIDX + 1} out of ${mQuiz.questions.length}'),
    ]);
  }
}
