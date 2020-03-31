/// Author: Jose G. Perez
/// These are the question-specific widgets and their implementations
import 'package:flutter/material.dart';
import 'package:quizapp/model/question.dart';

import 'model/networking.dart';

class MultipleChoiceWidget extends StatefulWidget {
  final Question mQuestion;

  MultipleChoiceWidget({Key key, this.mQuestion}) : super(key: key);

  QuestionState createState() => MultipleChoiceState(mQuestion);
}

class FillInTheBlankWidget extends StatefulWidget {
  final Question mQuestion;

  FillInTheBlankWidget({Key key, this.mQuestion}) : super(key: key);

  QuestionState createState() => FillInTheBlankState(mQuestion);
}

/// Contains the shared view logic between both types of questions
abstract class QuestionState extends State<StatefulWidget> {
  /// The question that is being represented
  Question mQuestion;

  /// The form which keeps track of validation and saving (if necessary)
  GlobalKey<FormState> _formKey = GlobalKey();

  QuestionState(this.mQuestion);

  /// Abstract method building the answer part of the question. Every widget has to override this
  Widget buildAnswerWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        buildStemWidget(),
        Form(
          key: _formKey,
          child: buildAnswerWidget(),
        ),
      ]),
    );
  }

  /// Updates the question and subsequently its state
  void updateQuestion(Question newQuestion) {
    setState(() => mQuestion = newQuestion);
  }

  /// Builds the stem part of the question, including the figure if included and valid
  Widget buildStemWidget() {
    var stemText = Text(mQuestion.stem ?? '', style: TextStyle(fontSize: 20));
    if (mQuestion.figureURL == null)
      return stemText;
    else
      return Column(
        children: [stemText, Image.network(baseFigureURL + mQuestion.figureURL)],
      );
  }

  /// Validation check for this state
  bool validate() => _formKey.currentState.validate();

  /// Saving method for this state
  void save() => _formKey.currentState.save();
}

class FillInTheBlankState extends QuestionState {
  /// Controller used to persist the user provided responses when navigating
  TextEditingController mController = TextEditingController();

  FillInTheBlankState(Question question) : super(question);

  Widget buildAnswerWidget() {
    mController.text = mQuestion.attemptedAnswer.toString();

    var textField = TextFormField(
      enabled: !mQuestion.isUnderReview,
      controller: mController,
      onSaved: (newValue) => mQuestion.attemptedAnswer = newValue,
      validator: (newValue) {
        if (newValue.isEmpty) return 'Answer cannot be empty';
        return null;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: 'Answer', icon: Icon(Icons.question_answer)),
    );

    if (mQuestion.isUnderReview) {
      return Column(children: [
        textField,
        Text(
          'Right Answer: ${mQuestion.correctAnswer}',
          style: TextStyle(color: Colors.green),
        )
      ]);
    } else {
      return textField;
    }
  }
}

class MultipleChoiceState extends QuestionState {
  /// Current selected multiple choice options
  String mCurrentOption = '';

  /// Error message to display (if any). Used for validation checks.
  String mErrorMessage = '';

  MultipleChoiceState(Question question) : super(question);

  @override
  Widget buildAnswerWidget() {
    return Column(children: buildOptionsWidget(mQuestion as MultipleChoice));
  }

  /// Builds the list of widgets representing the multiple choice options
  List<Widget> buildOptionsWidget(MultipleChoice mQuestion) {
    List<Widget> result = [];

    mCurrentOption = mQuestion.attemptedAnswer;
    mQuestion.options.forEach((option) {
      result.add(buildRadioWidget(mQuestion, option));
    });

    result.add(Center(child: Text(mErrorMessage, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))));
    return result;
  }

  /// Builds a single widget representing one multiple choice option
  RadioListTile<String> buildRadioWidget(MultipleChoice mQuestion, option) {
    // When reviewing, disable changing and highlight correct and incorrect answers
    var textColor = Colors.black;
    var bgColor = Colors.transparent;
    if (mQuestion.isUnderReview) {
      print('[Review] Selected: $option, Correct: ${mQuestion.options[mQuestion.correctAnswer]}');
      if (option == mCurrentOption) {
        bgColor = Colors.red;
        textColor = Colors.white;
      } else if (mQuestion.options[mQuestion.correctAnswer].toString() == option) {
        bgColor = Colors.green;
        textColor = Colors.white;
      }
    }

    void onChanged(newValue) {
      mQuestion.attemptedAnswer = newValue;
      setState(() => mCurrentOption = newValue);
    }

    return RadioListTile<String>(
        value: option,
        title: Text(option, style: TextStyle(fontSize: 20, color: textColor, backgroundColor: bgColor)),
        groupValue: mCurrentOption,
        onChanged: mQuestion.isUnderReview ? null : onChanged);
  }

  @override
  bool validate() {
    if (mCurrentOption == null || mCurrentOption.isEmpty) {
      setState(() => mErrorMessage = 'You need to select one of the options before going to another question');
      return false;
    }
    setState(() => mErrorMessage = '');
    return true;
  }
}
