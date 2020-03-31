/// Author: Jose G. Perez
import 'package:flutter/material.dart';
import 'package:quizapp/model/question.dart';

import 'model/quiz.dart';
import 'widgets.dart';

/// This page is in charge of the quiz taking navigation and reviewing navigation
class NavigateQuizPage extends StatefulWidget {
  NavigateQuizPage({Key key}) : super(key: key);

  @override
  _NavigateQuizPageState createState() => _NavigateQuizPageState();
}

class _NavigateQuizPageState extends State<NavigateQuizPage> {
  /// Current question index
  int currentQuestionIDX = 0;

  /// Key used to update the question state
  GlobalKey<QuestionState> _questionKey = GlobalKey();

  /// Checks if the current question is valid and if so, saves it
  /// Then it updates the question using the provided new index
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

  /// Builds the question widget depending on the current type of question
  Widget buildQuestionWidget(Quiz mQuiz) {
    Question currentQuestion = mQuiz.questions[currentQuestionIDX];
    if (currentQuestion is MultipleChoice)
      return MultipleChoiceWidget(key: _questionKey, mQuestion: currentQuestion);
    else
      return FillInTheBlankWidget(key: _questionKey, mQuestion: currentQuestion);
  }

  /// Builds the navigation components, in this case, the navigation buttons
  Widget buildNavigationWidget(Quiz mQuiz) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [buildPreviousButton(mQuiz), buildNextButton(mQuiz)],
    );
  }

  /// Builds the previous question button
  Widget buildPreviousButton(Quiz mQuiz) {
    bool isEnabled = (currentQuestionIDX > 0);
    void onPress() => validateAndUpdate(mQuiz, currentQuestionIDX - 1);
    return RaisedButton(
      child: Text('Previous Question'),
      onPressed: isEnabled ? onPress : null,
    );
  }

  /// Builds the next question button
  /// When we are on the last question, builds the submit button
  Widget buildNextButton(Quiz mQuiz) {
    bool isLast = (currentQuestionIDX == mQuiz.questions.length - 1);

    if (mQuiz.isReviewing) {
      return RaisedButton(
        child: Text(isLast ? 'Return To Login Page' : 'Next Question'),
        onPressed: () {
          if (isLast)
            Navigator.popUntil(context, ModalRoute.withName('login'));
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

  /// Builds the progress trackers at the bottom
  Widget buildProgress(Quiz mQuiz) {
    double value = (currentQuestionIDX + 1) / mQuiz.questions.length;
    return Column(children: [
      LinearProgressIndicator(value: value),
      Text('Question ${currentQuestionIDX + 1} out of ${mQuiz.questions.length}'),
    ]);
  }
}
