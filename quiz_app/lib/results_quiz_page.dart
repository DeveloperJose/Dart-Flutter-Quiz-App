// Author: Jose G. Perez
import 'package:flutter/material.dart';

import 'model/quiz.dart';

class ResultsQuizPage extends StatelessWidget {
  ResultsQuizPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Quiz mQuiz = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results Page'),
      ),
      body: Container(
          padding: EdgeInsets.all(30.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildGradeDisplay(mQuiz),
              buildReviewButton(context, mQuiz),
              buildReturnButton(context),
            ],
          )),
    );
  }

  Widget buildGradeDisplay(Quiz mQuiz) {
    QuizGrade grade = mQuiz.grade();
    var gradeColor = (grade.numericalGrade < 0.7) ? Colors.red : Colors.green;

    return Column(children: [
      Text(
        'You got ${grade.totalCorrect} questions correct out of ${grade.totalQuestions}.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 50),
      ),
      Text(
        'That gives you a ${grade.formatNumerical()}, an ${grade.formatLetter()}.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, color: gradeColor),
      ),
    ]);
  }

  Widget buildReturnButton(BuildContext context) {
    return RaisedButton(
      child: Text('Return To Quiz Creation Page'),
      onPressed: () => Navigator.popUntil(context, ModalRoute.withName('create_quiz')),
    );
  }

  Widget buildReviewButton(BuildContext context, Quiz mQuiz) {
    QuizGrade grade = mQuiz.grade();
    // Cannot review if you got a perfect score
    if (grade.isPerfect())
      return RaisedButton(child: Text('Cannot Review With A Perfect Score'));
    else
      return RaisedButton(
        child: Text('Review Incorrect Answers'),
        onPressed: () {
          mQuiz.questions.removeWhere((question) => question.isCorrectAnswer());
          Navigator.pushNamed(context, 'navigate_quiz', arguments: mQuiz);
        },
      );
  }
}
