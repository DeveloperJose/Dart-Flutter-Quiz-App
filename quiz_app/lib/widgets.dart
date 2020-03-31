// Author: Jose G. Perez
import 'package:flutter/material.dart';
import 'package:quizapp/model/question.dart';

import 'model/quiz.dart';

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

abstract class QuestionState extends State<StatefulWidget> {
  Question mQuestion;
  GlobalKey<FormState> _formKey = GlobalKey();

  QuestionState(this.mQuestion);

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

  void updateQuestion(Question newQuestion) {
    setState(() => mQuestion = newQuestion);
  }

  Widget buildStemWidget() {
    return Text(mQuestion.stem ?? '', style: TextStyle(fontSize: 25,));
  }

  Widget buildAnswerWidget();

  bool validate() => _formKey.currentState.validate();

  void save() => _formKey.currentState.save();
}

class FillInTheBlankState extends QuestionState {
  TextEditingController mController = TextEditingController();

  FillInTheBlankState(Question question) : super(question);

  Widget buildAnswerWidget() {
    mController.text = mQuestion.attemptedAnswer.toString();

    return TextFormField(
      controller: mController,
      onSaved: (newValue) => mQuestion.attemptedAnswer = newValue,
      validator: (newValue) {
        if (newValue.isEmpty) return 'Answer cannot be empty';
        return null;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: 'Answer', icon: Icon(Icons.question_answer)),
    );
  }
}

class MultipleChoiceState extends QuestionState {
  String mCurrentOption = '';
  String mErrorMessage = '';

  MultipleChoiceState(Question question) : super(question);

  @override
  Widget buildAnswerWidget() {
    return Column(children: buildOptionsWidget(mQuestion as MultipleChoice));
  }

  List<Widget> buildOptionsWidget(MultipleChoice mQuestion) {
    List<Widget> result = [];

    mQuestion.options.forEach((option) {
      result.add(buildRadioWidget(mQuestion, option));
    });

    result.add(Center(child: Text(mErrorMessage, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))));
    return result;
  }

  RadioListTile<String> buildRadioWidget(MultipleChoice mQuestion, option) {
    mCurrentOption = mQuestion.attemptedAnswer;
    return RadioListTile<String>(
      value: option,
      title: Text(option, style: TextStyle(fontSize: 20)),
      groupValue: mCurrentOption,
      onChanged: (newValue) {
        mQuestion.attemptedAnswer = newValue;
        setState(() => mCurrentOption = newValue);
      },
    );
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
