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
        title: Text(mQuiz.isReviewing ? 'Reviewing Quiz Page' : 'Navigate Quiz Page'),
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
    bool isLast = (currentQuestionIDX == mQuiz.questions.length - 1);

    if (mQuiz.isReviewing) {
      return RaisedButton(
        child: Text(isLast ? 'Return To Quiz Creation Page' : 'Next Question'),
        onPressed: () {
          if (isLast)
            Navigator.popUntil(context, ModalRoute.withName('create_quiz'));
          else
            validateAndUpdate(mQuiz, currentQuestionIDX + 1);
        },
      );
    } else {
      return RaisedButton(
        child: Text(isLast ? 'Submit and Grade' : 'Next Question'),
        onPressed: () {
          if (isLast) {
            // Go to grading screen
            bool isEnabled = _questionKey.currentState?.validate();
            if (isEnabled) {
              mQuiz.isReviewing = true;
              Navigator.pushNamed(context, 'results_quiz', arguments: mQuiz);
            }
          } else {
            validateAndUpdate(mQuiz, currentQuestionIDX + 1);
          }
        },
      );
    }
  }

  Widget buildProgress(Quiz mQuiz) {
    double value = (currentQuestionIDX + 1) / mQuiz.questions.length;
    return Column(children: [
      LinearProgressIndicator(value: value),
      Text('Question ${currentQuestionIDX + 1} out of ${mQuiz.questions.length}'),
    ]);
  }
}
