// Author: Jose G. Perez
import 'package:flutter/material.dart';
import 'package:quizapp/model/question.dart';

import 'model/quiz.dart';

class QuestionWidget extends StatefulWidget {
  final Question mQuestion;

  QuestionWidget({Key key, this.mQuestion}) : super(key: key);

  QuestionState createState() {
    if (mQuestion is FillInTheBlank)
      return FillInTheBlankState();
    else
      return FillInTheBlankState();
  }
}

abstract class QuestionState extends State<QuestionWidget> {
  GlobalKey<FormState> _formKey = GlobalKey();

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

  Widget buildStemWidget();

  Widget buildAnswerWidget();

  bool validate() => _formKey.currentState.validate();

  void save() => _formKey.currentState.save();
}

class FillInTheBlankState extends QuestionState {
  var controller = TextEditingController();

  @override
  Widget buildStemWidget() {
    return Text(widget.mQuestion.stem);
  }

  @override
  Widget buildAnswerWidget() {
    controller.text = widget.mQuestion.attemptedAnswer.toString();

    return TextFormField(
      controller: controller,
      onSaved: (newValue) => widget.mQuestion.attemptedAnswer = newValue,
      validator: (newValue) {
        if (newValue.isEmpty) return 'Answer cannot be empty';
        return null;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: 'Answer', icon: Icon(Icons.question_answer)),
    );
  }
}
